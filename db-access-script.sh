
#Environment
environment=preprod

#Initialize the admin Users for MongoDB
pango_admin_users=("pangoRootAdmin" "pangoUserAdmin")

#Initialize the Read Only Users for MongoDB
pango_read_users=("pangoReadUser" "pangoVerifyReadUser")

#Initialize the Read Write Users for MongoDB
pango_rw_users=("pangoWriteUser" "pangoVerifyWriteUser")

#####Password Section for Users in Mongodb ###############
##########################################################

#Initialize the Passwords for admin Users in PREPROD
pango_admin_pwd=("pangoRootAdminPass10" "pangoUserAdminPass10")

#Initialize the Passwords for Read Only Users in MongoDB in PREPROD
pango_read_pwd=("pangoPreprodReadUsrPass10" "pangoPreprodVerifyReadUsrPass10")

#Initialize the Passwords for Read Write Users in MongoDB in PREPROD
pango_rw_pwd=("pangoPreprodWriteUsrPass10" "pangoPreprodVerifyWriteUsrPass10")


#Check if Mongo DB node is Primary
`mongo --eval 'db.isMaster().ismaster' | grep true 2>/dev/null`
result=$?

#Run this script only on MongoDB node
if [ $result -eq 0 ]; then
   
    echo "================Creating Admin users in MongoDB========================================================"

     mongo admin --eval 'db.createUser({ user: "'${pango_admin_users[0]}'",  pwd: "'${pango_admin_pwd[0]}'",  roles: [ { role: "root", db: "admin" } , { role: "userAdminAnyDatabase", db: "admin" } ] } );' 2>/dev/null 
	 
     mongo pango --eval 'db.createUser( { user: "'${pango_admin_users[1]}'", pwd: "'${pango_admin_pwd[1]}'", roles: [ { role: "userAdmin", db: "pango" } ] } );' 2>/dev/null
	 
     mongo pango-verification --eval 'db.createUser( { user: "'${pango_admin_users[1]}'", pwd: "'${pango_admin_pwd[1]}'", roles: [ { role: "userAdmin", db: "pango-verification" } ] } );' 2>/dev/null


    echo "================Creating Read Only users in Mongo DB========================================================"
    
    mongo pango --eval 'db.createUser( { user: "'${pango_read_users[0]}'", pwd: "'${pango_read_pwd[0]}'", roles: [{ role: "read", db: "pango" }] } );' 2>/dev/null
	
	 mongo pango-verification --eval 'db.createUser( { user: "'${pango_read_users[1]}'", pwd: "'${pango_read_pwd[1]}'", roles: [{ role: "read", db: "pango-verification" }] } );' 2>/dev/null
  
	echo "==================== Completed Read Only users creation in Mongo DB !!!========================================"

	echo "==================================Creating Read Write users in Mongo DB======================================= "

    mongo pango --eval 'db.createUser( { user: "'${pango_rw_users[0]}'", pwd: "'${pango_rw_pwd[0]}'", roles: [{ role: "readWrite", db: "pango" }] } );' 2>/dev/null
	
	mongo pango-verification --eval 'db.createUser( { user: "'${pango_rw_users[1]}'", pwd: "'${pango_rw_pwd[1]}'", roles: [{ role: "readWrite", db: "pango-verification" }] } );' 2>/dev/null

	echo "================Completed Read Write users creation in Mongo DB=================================================="
else
    echo "This script need to run on Mongo Primary node"
    exit 1      
fi
