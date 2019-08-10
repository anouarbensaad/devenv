
from __future__ import print_function
import os, sys , time ,subprocess
print ('''
========= MENU ==========
1- Create VM
''')
def user():
    U = os.popen("who |tr -s ' ' |cut -d' ' -f1").read().splitlines()
    for user in U:
        return user
def uid():
    I = os.popen("cat /etc/passwd|grep %s|cut -d ':' -f3" % user()).read().splitlines()
    for uid in I:
        return int(uid)
def gid():
    G = os.popen("cat /etc/passwd|grep %s|cut -d ':' -f4" % user()).read().splitlines()
    for gid in G:
        return int(gid)
def vagrantconf():
        path= ('/home/%s/.vagrant.d/' % user())
        os.chown(path,uid(),gid())
        print('permission changed.')

def envtest():
    # Choose Envirement Type.
    ENV_TYPE = ['whiptail', '--title', "Envirement Type", '--menu', "Choose Envirement", '11', '73', '3',
    "Front End", " Allow connections to other hosts",
    "Back End", " Allow connections from other hosts",
    "Other ", " Allow mounting of local devices",]
    p = subprocess.Popen(ENV_TYPE)
    p.communicate()

    # Front End Envirement.
    cmd = ['whiptail', '--title', "Front End Envirments", '--checklist', "Choose Frameworks", '20', '78', '4',
    " Angular", " Allow connections to other hosts", "ON",
    " React", " Allow connections from other hosts", "OFF",
    " Vue.JS", " Allow mounting of local devices", "OFF",
    " Preact.JS", " Allow mounting of remote devices", "OFF"]
    p = subprocess.Popen(cmd)
    p.communicate()

    # Back End Envirement.
    cmd = ['whiptail', '--title', "Back End Envirments", '--checklist', "Choose Frameworks", '20', '78', '4',
    " Spring Boot", " Allow connections to other hosts", "ON",
    " Express", " Allow connections from other hosts", "OFF",
    " Ruby on Rails", " Allow mounting of local devices", "OFF",
    " Laravel Lumen ", " Allow mounting of remote devices", "OFF",
    " Django", " Allow connections from other hosts", "OFF",
    " Symfony", " Allow mounting of local devices", "OFF",]
    p = subprocess.Popen(cmd)
    p.communicate()

    # Others Envirement.
    cmd = ['whiptail', '--title', "Other Envirments", '--checklist', "Choose Apps", '20', '78', '4',
    " Apache2", " Allow connections to other hosts", "ON",
    " Nginx", " Allow connections from other hosts", "OFF",
    " php7.2", " Allow mounting of local devices", "OFF",]
    p = subprocess.Popen(cmd)
    p.communicate()

# Generate Vagrantfile

def vagrantgen():
    NAME     = input("VM Name : ")
    MEM      = input("VM Memory : ")
    envtest()
    f= open("Vagrantfile","w+")
    f.write('''
Vagrant.configure("2") do |config|
 config.vm.box = "ubuntu/trusty64"
 config.vm.provider "virtualbox" do |vb|
  vb.gui = true
  vb.name   = "%s"
  vb.memory = "%s"
 end
end
    ''' % (NAME , MEM))
    f.close()


vagrantconf()
vagrantgen()