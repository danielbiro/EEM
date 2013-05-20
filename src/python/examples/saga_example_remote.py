import sys
import saga

REMOTE_HOST = "albert.einstein.yu.edu"

def main():
    try:
        # Your ssh identity on the remote machine
        ctx = saga.Context("ssh")
        ctx.user_id = "cameron"

        session = saga.Session()
        session.add_context(ctx)

        # Create a job service object that represent a remote pbs cluster.
        # The keyword 'pbs' in the url scheme triggers the PBS adaptors
        # and '+ssh' enables PBS remote access via SSH.
        #js = saga.job.Service("pbs+ssh://%s" % REMOTE_HOST, session=session)
        js = saga.job.Service("sge+ssh://%s" % REMOTE_HOST, session=session)
        #js = saga.job.Service("sge+ssh://cameron.albert.aecom.yu.edu", session=session)
        
        # describe our job
        jd = saga.job.Description()

        # Next, we describe the job we want to run. A complete set of job
        # description attributes can be found in the API documentation.
        jd.environment     = {'MYOUTPUT':'"Hello from SAGA"'}
        jd.executable      = '/bin/echo'
        jd.arguments       = ['$MYOUTPUT']
        jd.output          = "mysagajob.stdout"
        jd.error           = "mysagajob.stderr"
        jd.spmd_variation  = 'serial'
        # $ qconf -sql
        # $ qconf -sq all.q
        jd.queue = "free.q"

        # Create a new job from the job description. The initial state of
        # the job is 'New'.
        myjob = js.create_job(jd)

        # Check our job's id and state
        print "Job ID    : %s" % (myjob.id)
        print "Job State : %s" % (myjob.state)

        print "\n...starting job...\n"

        # Now we can start our job.
        myjob.run()

        print "Job ID    : %s" % (myjob.id)
        print "Job State : %s" % (myjob.state)

        print "\n...waiting for job...\n"
        # wait for the job to either finish or fail
        myjob.wait()

        print "Job State : %s" % (myjob.state)
        print "Exitcode  : %s" % (myjob.exit_code)

        outfilesource = 'sftp://%s/home/cameron/mysagajob.stdout' % REMOTE_HOST
        outfiletarget = 'file://localhost/tmp/'
        out = saga.filesystem.File(outfilesource, session=session)
        out.copy(outfiletarget)

        print "Staged out %s to %s (size: %s bytes)\n" % (outfilesource, outfiletarget, out.get_size())


        return 0

    except saga.SagaException, ex:
        # Catch all saga exceptions
        print "An exception occured: (%s) %s " % (ex.type, (str(ex)))
        # Trace back the exception. That can be helpful for debugging.
        print " \n*** Backtrace:\n %s" % ex.traceback
        return -1


if __name__ == "__main__":
    sys.exit(main())