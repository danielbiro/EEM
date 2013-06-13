import os
import sys
import time
import saga

# import libraries
import numpy as np

# import local
import eem
import dbeem

# time
from datetime import datetime

REMOTE_HOST = "albert.einstein.yu.edu"
REMOTE_JOB_ENDPOINT = "sge+ssh://" + REMOTE_HOST
REMOTE_FILE_ENDPOINT = "sftp://" + REMOTE_HOST

# define parameters
# ========================================

# testing
# minamp = 1
# maxamp = 3
# amps = range(minamp,maxamp)

# minperiod = 3
# maxperiod = 5
# periods = range(minperiod,maxperiod)

# minmix = 0.5
# maxmix = 0.7
# ssmixs = np.arange(minmix,maxmix,0.1)

# mutrate = 0.1
# popsize = 100
# maxtime = 10**3

# simulation
minamp = 2
maxamp = 3
amps = range(minamp,maxamp)

minperiod = 2
maxperiod = 31
periods = range(minperiod,maxperiod)

minmix = 0.1
maxmix = 1.0
ssmixs = np.arange(minmix,maxmix,0.1)

mutrate = 0.1
popsize = 1000
maxtime = 10**5/2


if __name__ == "__main__":
    try:
        # Your ssh identity on the remote machine
        ctx = saga.Context("ssh")
        ctx.user_id = "cameron"

        session = saga.Session()
        session.add_context(ctx)

        # list that holds the jobs
        jobs = []

        now = datetime.now()
        tstring = now.strftime("%Y%m%dT%H%M%S")

        # create a working directory in /scratch
        remoteresultsdirname = '%s/%s/results/eem%s/' % (REMOTE_FILE_ENDPOINT, 'home/cameron',tstring)

        workdir = saga.filesystem.Directory(remoteresultsdirname, saga.filesystem.CREATE,
                                            session=session)

        localresultsdirname  = 'file://localhost/%s/results/eem%s' % (os.getcwd(),tstring)
        localresultsdir = saga.filesystem.Directory(localresultsdirname, saga.filesystem.CREATE,
                                            session=session)

        # copy the executable and wrapper script to the remote host
        mbwrapper = saga.filesystem.File('file://localhost/%s/eem.sh' % os.getcwd())
        mbwrapper.copy(workdir.get_url())
        #mbexe = saga.filesystem.File('file://localhost/%s/eem.py' % os.getcwd())
        #mbexe.copy(workdir.get_url())

        localdir = saga.filesystem.Directory('sftp://localhost/%s' % os.getcwd())
        pyfiles = localdir.list()

        for f in pyfiles :
            if f.path.endswith('eem.py') :
                localdir.copy (f, workdir.get_url())


        # the saga job services connects to and provides a handle
        # to a remote machine. In this case, it's your machine.
        # fork can be replaced with ssh here:
        jobservice = saga.job.Service(REMOTE_JOB_ENDPOINT, session=session)
        outputfile = 'test.db'

        for amp in amps:
            for period in periods:
                for ssmix in ssmixs:

                    # describe a single Mandelbrot job. we're using the
                    # directory created above as the job's working directory
                    #outputfile = 'eem_%d_%d_%.2f.db' % (amp, period, ssmix)

                    jd = saga.job.Description()
                    #jd.queue             = "development"
                    jd.wall_time_limit   = 10
                    jd.total_cpu_count   = 1
                    jd.working_directory = workdir.get_url().path
                    jd.executable        = 'sh'
                    jd.arguments         = ['eem.sh', amp, period, ssmix,
                                            mutrate, popsize, maxtime, outputfile]
                    jd.spmd_variation  = 'serial'
                    # $ qconf -sql
                    # $ qconf -sq all.q
                    jd.queue = "free.q"

                    # create the job from the description
                    # above, launch it and add it to the list of jobs
                    job = jobservice.create_job(jd)
                    job.run()
                    jobs.append(job)
                    print ' * Submitted %s. Output will be written to: %s' % (
                        job.id, outputfile)

        # wait for all jobs to finish
        while len(jobs) > 0:
            for job in jobs:
                jobstate = job.get_state()
                print ' * Job %s status: %s' % (job.id, jobstate)
                if jobstate in [saga.job.DONE, saga.job.FAILED]:
                    jobs.remove(job)
            time.sleep(5)

        # copy image tiles back to our 'local' directory
        # for image in workdir.list('*.db'):
        #     print ' * Copying %s/%s/%s back to %s' % (REMOTE_FILE_ENDPOINT,
        #                                               workdir.get_url(),
        #                                               image, os.getcwd())
        #     workdir.copy(image, 'file://localhost/%s/' % os.getcwd())
        for resultfiles in workdir.list('*'):
            workdir.copy(resultfiles, localresultsdir.get_url())

        # stitch together the final image
        # fullimage = Image.new('RGB', (imgx, imgy), (255, 255, 255))
        # print ' * Stitching together the whole fractal: mandelbrot_full.gif'
        # for x in range(0, tilesx):
        #     for y in range(0, tilesy):
        #         partimage = Image.open('tile_x%s_y%s.gif' % (x, y))
        #         fullimage.paste(partimage,
        #                         (imgx/tilesx*x, imgy/tilesy*y,
        #                          imgx/tilesx*(x+1), imgy/tilesy*(y+1)))
        # fullimage.save("mandelbrot_full.gif", "GIF")
        sys.exit(0)

    except saga.SagaException, ex:
        # Catch all saga exceptions
        print "An exception occured: (%s) %s " % (ex.type, (str(ex)))
        # Trace back the exception. That can be helpful for debugging.
        print " \n*** Backtrace:\n %s" % ex.traceback
        sys.exit(-1)

    except KeyboardInterrupt:
    # ctrl-c caught: try to cancel our jobs before we exit
        # the program, otherwise we'll end up with lingering jobs.
        for job in jobs:
            job.cancel()
        sys.exit(-1)
