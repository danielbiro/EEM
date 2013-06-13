#import os
import sys

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy import ForeignKey
from sqlalchemy.orm import relationship, backref
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, Float, String
from sqlalchemy.schema import MetaData
from sqlalchemy.schema import CreateSchema

def simdbsm(db_url='sqlite:///:memory:', schemaid=1, initflag=0):

  # database setup
  # ==========================

  # Connect
  # ====================
  # url info
  # http://docs.sqlalchemy.org/en/rel_0_8/core/engines.html?highlight=engine#sqlite
  engine = create_engine(db_url, echo=False)

  simname = 'eem' + str(schemaid)

  if initflag:
    engine.execute(CreateSchema(simname))

  mymeta = MetaData(schema=simname)
  Base = declarative_base(metadata=mymeta)

  class Simulation(Base):
     __tablename__ = 'simulations'

     id = Column(Integer, primary_key=True)
     amplitude = Column(Integer)
     period = Column(Integer)
     ssmix = Column(Float)
     mutrate = Column(Float)
     popsize = Column(Integer)

     individuals = relationship("Individual", backref='simulation', cascade="all, delete, delete-orphan")

     def __init__(self, amplitude, period, ssmix, mutrate, popsize):
          self.amplitude = amplitude
          self.period = period
          self.ssmix = ssmix
          self.mutrate = mutrate
          self.popsize = popsize

     def __repr__(self):
        return "<Simulation( id=%d, amp=%d, period=%d, ssmix=%.2f, mutrate=%.2f, popsize=%d)>" %\
         (self.id, self.amplitude, self.period, self.ssmix,\
          self.mutrate, self.popsize)

  class Individual(Base):
     __tablename__ = 'individuals'

     id = Column(Integer, primary_key=True)
     proportion = Column(Float, nullable=False)
     mean = Column(Float, nullable=False)
     std = Column(Float, nullable=False)
     simulation_id = Column(Integer, ForeignKey('simulations.id'))

     def __init__(self, proportion, mean, std):
               self.proportion = proportion
               self.mean = mean
               self.std = std

     def __repr__(self):
         return "<Individual(simid=%d, id=%d, proportion=%.2f, mean=%.2f, std=%.2f)>" %\
          (self.simulation_id, self.id, self.proportion, self.mean, self.std)

  if initflag:
    Base.metadata.create_all(engine)

  # creating a session
  # ====================

  Session = sessionmaker()
  Session.configure(bind=engine)
  session = Session()

  return session, Simulation, Individual

if __name__ == "__main__":

  args = sys.argv[1:]
  if len(args) < 3:
      print "Usage: python %s db_url=sqlite:///:memory: schemaid=1 initflag=0" % __file__
      sys.exit(-1)

  dburl = str(sys.argv[1])
  schemaid = str(sys.argv[2])
  initflag = int(sys.argv[3])

  # filename = None
  # if len(args) == 7:
  #     filename = str(sys.argv[7])

  simdbsm(dburl, schemaid, initflag)
  sys.exit(0)
# Working with Related Objects
# ====================

#sim1 = Simulation(2, 4, 0.9, 0.1, 1000)

# sim1.individuals = []
# sim1.individuals = [
#                  Individual(0.2,0,0.1),
#                  Individual(0.2,0,0.1),
#                  Individual(0.2,0,0.4)]

# sim1.individuals.append(Individual(0.2,0,0.4))

# session.add(sim1)
# session.commit()

# sim2 = Simulation(2, 4, 0.5, 0.1, 1000)
# sim2.individuals = [
#                  Individual(0.2,0,0.1),
#                  Individual(0.2,0,0.1),
#                  Individual(0.2,0,0.5)]

# session.add(sim2)
# session.commit()

# print session.query(Simulation).all()
# print session.query(Individual).all()

# session.query(Simulation).join(Individual).\
#          filter(Individual.std==0.5).\
#          all()

# test1Sim1 = session.query(Individual).\
# 	filter_by(proportion=0.2).one()

# test2Sim1 = session.query(Individual).\
# 	filter_by(proportion=0.2).all()

# test3Sim1 = session.query(Individual).\
# 	filter_by(std=0.1).all()
