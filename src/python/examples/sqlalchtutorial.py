import sqlalchemy

# Connect
# ====================

from sqlalchemy import create_engine
engine = create_engine('sqlite:///:memory:', echo=False)

# declare a mapping
# ====================

from sqlalchemy.ext.declarative import declarative_base
Base = declarative_base()

from sqlalchemy import Column, Integer, String
class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True)
    name = Column(String)
    fullname = Column(String)
    password = Column(String)

    def __init__(self, name, fullname, password):
        self.name = name
        self.fullname = fullname
        self.password = password

    def __repr__(self):
       return "<User('%s','%s', '%s')>" % (self.name, self.fullname, self.password)

Base.metadata.create_all(engine) 

# creating a session
# ====================
from sqlalchemy.orm import sessionmaker
Session = sessionmaker()
Session.configure(bind=engine)
session = Session()

# adding new objects
# ====================
ed_user = User('ed', 'Ed Jones', 'edspassword')
session.add(ed_user)

our_user = session.query(User).filter_by(name='ed').first() 

session.add_all([
    User('wendy', 'Wendy Williams', 'foobar'),
    User('mary', 'Mary Contrary', 'xxg527'),
    User('fred', 'Fred Flinstone', 'blah')])

ed_user.password = 'f8s7ccs'

session.dirty

session.new

session.commit()

# rollback
# ====================
ed_user.name = 'Edwardo'

fake_user = User('fakeuser', 'Invalid', '12345')
session.add(fake_user)

session.query(User).filter(User.name.in_(['Edwardo', 'fakeuser'])).all() 

session.rollback()

ed_user.name

fake_user in session

session.query(User).filter(User.name.in_(['ed', 'fakeuser'])).all()

# querying
# ====================
for instance in session.query(User).order_by(User.id): 
    print instance.name, instance.fullname

for name, fullname in session.query(User.name, User.fullname): 
    print name, fullname    

for row in session.query(User, User.name).all(): 
    print row.User, row.name

for row in session.query(User.name.label('name_label')).all(): 
    print(row.name_label)

query = session.query(User).filter(User.name.like('%ed')).order_by(User.id)
query.all()

# building a relationship
# ====================

from sqlalchemy import ForeignKey
from sqlalchemy.orm import relationship, backref

class Address(Base):
    __tablename__ = 'addresses'
    id = Column(Integer, primary_key=True)
    email_address = Column(String, nullable=False)
    user_id = Column(Integer, ForeignKey('users.id'))

    user = relationship("User", backref=backref('addresses', order_by=id))

    def __init__(self, email_address):
        self.email_address = email_address

    def __repr__(self):
        return "<Address('%s')>" % self.email_address

Base.metadata.create_all(engine)

# Working with Related Objects
# ====================

jack = User('jack', 'Jack Bean', 'gjffdd')
jack.addresses = [
                 Address(email_address='jack@google.com'),
                 Address(email_address='j25@yahoo.com')]

session.add(jack)
session.commit()

jack = session.query(User).\
	filter_by(name='jack').one()                  

# query with joins
# ====================	

for u, a in session.query(User, Address).\
                     filter(User.id==Address.user_id).\
                     filter(Address.email_address=='jack@google.com').\
                     all():   
     print u, a

session.query(User).join(Address).\
         filter(Address.email_address=='jack@google.com').\
         all()

# Aliasing
# ====================	    

from sqlalchemy.orm import aliased
adalias1 = aliased(Address)
adalias2 = aliased(Address)
for username, email1, email2 in \
     session.query(User.name, adalias1.email_address, adalias2.email_address).\
     join(adalias1, User.addresses).\
     join(adalias2, User.addresses).\
     filter(adalias1.email_address=='jack@google.com').\
     filter(adalias2.email_address=='j25@yahoo.com'):
     print username, email1, email2          

# Deleting
# ====================	    

session.delete(jack)
session.query(User).filter_by(name='jack').count()

session.query(Address).filter(
     Address.email_address.in_(['jack@google.com', 'j25@yahoo.com'])
  ).count()

# delete does not propagate

# configure delete-delete orphan cascade

session.close()
Base = declarative_base()

class User(Base):
     __tablename__ = 'users'

     id = Column(Integer, primary_key=True)
     name = Column(String)
     fullname = Column(String)
     password = Column(String)

     addresses = relationship("Address", backref='user', cascade="all, delete, delete-orphan")

     def __repr__(self):
        return "<User('%s','%s', '%s')>" % (self.name, self.fullname, self.password)

class Address(Base):
     __tablename__ = 'addresses'
     id = Column(Integer, primary_key=True)
     email_address = Column(String, nullable=False)
     user_id = Column(Integer, ForeignKey('users.id'))

     def __repr__(self):
         return "<Address('%s')>" % self.email_address

jack = session.query(User).get(5)
del jack.addresses[1]

session.query(Address).filter(\
     Address.email_address.in_(['jack@google.com', 'j25@yahoo.com'])).count()

session.delete(jack)

session.query(User).filter_by(name='jack').count()

session.query(Address).filter(\
   Address.email_address.in_(['jack@google.com', 'j25@yahoo.com'])).count()
