from __future__ import print_function
import os, sys , time ,subprocess
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
def dockerfile_build():
        print("A#A")
def frontEnd_Ansible_playbook(xfram):
        if(xfram == "Angular"):
                print("Installing Angular. [NEED ANSIBLE PLUGIN]")
        if(xfram == "React"):
                print("Installing React. [NEED ANSIBLE PLUGIN]")
        if(xfram == "Vue.JS"):
                print("Installing Vue.JS. [NEED ANSIBLE PLUGIN]")
        if(xfram == "Preact.JS"):
                print("Installing Preact.JS. [NEED ANSIBLE PLUGIN]")
def backEnd_Ansible_playbook(xfram):
        if(xfram == "Spring Boot"):
                print("Installing Spring Boot. [NEED ANSIBLE PLUGIN]")
        if(xfram == "Express"):
                print("Installing Express. [NEED ANSIBLE PLUGIN]")
        if(xfram == "Ruby on Rails"):
                print("Installing Ruby on Rails. [NEED ANSIBLE PLUGIN]")
        if(xfram == "Laravel Lumen"):
                print("Installing Laravel Lumen. [NEED ANSIBLE PLUGIN]")
        if(xfram == "Django"):
                print("Installing Django. [NEED ANSIBLE PLUGIN]")
        if(xfram == "Symfony"):
                print("Installing Symfony. [NEED ANSIBLE PLUGIN]")
def others_Ansible_playbook(xapp):
        if(xapp == "Apache2"):
                print("Installing Apache2. [NEED ANSIBLE PLUGIN]")
        if(xapp == "Nginx"):
                print("Installing Nginx. [NEED ANSIBLE PLUGIN]")
        if(xapp == "php7.2"):
                print("Installing php7.2. [NEED ANSIBLE PLUGIN]")
def Menu():
# Choose Envirement Type.
        ENV_TYPE = ['whiptail', '--title',  "Envirement Type", '--menu', "Choose Envirement", '11', '73', '3',
        "Front End", " Allow connections to other hosts",
        "Back End", " Allow connections from other hosts",
        "Other", " Allow mounting of local devices",
        ]
        envtype = subprocess.run(ENV_TYPE , stderr=subprocess.PIPE).stderr.decode('utf-8')
        print(envtype)
        if envtype == "Front End": 
                FE_ENV = ['whiptail', '--title', "Front End Envirments", '--checklist', "Choose Frameworks", '20', '78', '4',
                "Angular", " Allow connections to other hosts", "OFF",
                "React", " Allow connections from other hosts", "OFF",
                "Vue.JS", " Allow mounting of local devices", "OFF",
                "Preact.JS", " Allow mounting of remote devices", "OFF"]
                feenv = subprocess.run(FE_ENV , stderr=subprocess.PIPE).stderr.decode('utf-8').replace('\"','').split()
                for i in range(len(feenv)):
                        frontEnd_Ansible_playbook(feenv[i])
        elif envtype == "Back End":
                BE_ENV = ['whiptail', '--title', "Back End Envirments", '--checklist', "Choose Frameworks", '20', '78', '6',
                "Spring Boot", " Allow connections to other hosts", "OFF",
                "Express", " Allow connections from other hosts", "OFF",
                "Ruby on Rails", " Allow mounting of local devices", "OFF",
                "Laravel Lumen", " Allow mounting of remote devices", "OFF",
                "Django", " Allow connections from other hosts", "OFF",
                "Symfony", " Allow mounting of local devices", "OFF",]
                beenv = subprocess.run(BE_ENV , stderr=subprocess.PIPE).stderr.decode('utf-8').replace('\"','').split()
                for i in range(len(beenv)):
                        backEnd_Ansible_playbook(beenv[i])
    # Back End Envirement.
        else:
        # Others Envirement.
                O_ENV = ['whiptail', '--title', "Other Envirments", '--checklist', "Choose Apps", '20', '78', '3',
                "Apache2", " Allow connections to other hosts", "OFF",
                "Nginx", " Allow connections from other hosts", "OFF",
                "php7.2", " Allow mounting of local devices", "OFF",]
                oenv = subprocess.run(O_ENV , stderr=subprocess.PIPE).stderr.decode('utf-8').replace('\"','').split()
                for i in range(len(oenv)):
                        others_Ansible_playbook(oenv[i])

# Generate AnsibleContainer
Menu()