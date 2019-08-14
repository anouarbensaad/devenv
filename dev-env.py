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
            print(feenv[i])
    elif envtype == "Back End":
        BE_ENV = ['whiptail', '--title', "Back End Envirments", '--checklist', "Choose Frameworks", '20', '78', '6',
        "Spring Boot", " Allow connections to other hosts", "OFF",
        "Express", " Allow connections from other hosts", "OFF",
        "Ruby on Rails", " Allow mounting of local devices", "OFF",
        "Laravel Lumen ", " Allow mounting of remote devices", "OFF",
        "Django", " Allow connections from other hosts", "OFF",
        "Symfony", " Allow mounting of local devices", "OFF",]
        beenv = subprocess.run(BE_ENV , stderr=subprocess.PIPE).stderr.decode('utf-8').replace('\"','').split()
        print(beenv)
    # Back End Envirement.
    else:
        # Others Envirement.
        O_ENV = ['whiptail', '--title', "Other Envirments", '--checklist', "Choose Apps", '20', '78', '3',
        "Apache2", " Allow connections to other hosts", "OFF",
        "Nginx", " Allow connections from other hosts", "OFF",
        "php7.2", " Allow mounting of local devices", "OFF",]
        oenv = subprocess.run(O_ENV , stderr=subprocess.PIPE).stderr.decode('utf-8').replace('\"','').split()
        print(oenv)
# Generate AnsibleContainer
Menu()
