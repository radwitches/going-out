# -----
# On server
# -----
sudo yum update -y
sudo yum groupinstall -y "Development Tools"
sudo yum install -y gcc libxml2 libxml2-devel libxslt libxslt-devel git nginx ruby23 ruby23-devel

# Using install script instead
# sudo yum install -y postgresql postgresql-server postgresql-devel postgresql-contrib postgresql-docs

sudo yum install -y nodejs npm --enablerepo=epel

sudo update-alternatives --config ruby # INTERACTIVE!!!

sudo service postgresql initdb
sudo /sbin/chkconfig --levels 235 postgresql on
sudo service postgresql start
sudo -u postgres createuser ec2-user -s

gem2.3 install bundler

mkdir app
mkdir repo
cd repo
git init --bare

cat << EOF > hooks/post-receive
#!/bin/bash

GIT_DIR=/home/ec2-user/repo
WORK_TREE=/home/ec2-user/app
export RAILS_ENV=production
. ~/.bash_profile

while read oldrev newrev ref
do
    if [[ \$ref =~ .*/master\$ ]];
    then
        echo "Master ref received.  Deploying master branch to production..."
        mkdir -p \$WORK_TREE
        git --work-tree=\$WORK_TREE --git-dir=\$GIT_DIR checkout -f
        mkdir -p \$WORK_TREE/shared/pids \$WORK_TREE/shared/sockets \$WORK_TREE/shared/log

        # start deploy tasks
        cd \$WORK_TREE
        bundle install
        rake db:create
        rake db:migrate
        rake assets:precompile
        sudo restart puma-manager
        sudo service nginx restart
        # end deploy tasks
        echo "Git hooks deploy complete"
    else
        echo "Ref \$ref successfully received.  Doing nothing: only the master branch may be deployed on this server."
    fi
done
EOF

chmod +x hooks/post-receive

# -----
# Locally
# -----
git remote add prod govhack:repo
git push prod
