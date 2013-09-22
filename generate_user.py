#!/usr/bin/env python
import os
import gflags
import sys
import shutil
import string
from time import time
from itertools import chain
from random import seed, choice, sample
from subprocess import Popen, PIPE
from passlib.hash import sha256_crypt

FLAGS=gflags.FLAGS

gflags.DEFINE_boolean('gensshkey', True, 'Auto generate ssh key for user')
gflags.DEFINE_string('user', 'waijiao', 'username', short_name='u')
gflags.DEFINE_string('passwd', '', 'password, leave empty will generate random password', short_name='p')
gflags.DEFINE_string('sshpasswd', '', 'ssh password, leave empty will generate random password', short_name='s')
gflags.DEFINE_string('pubkey', '', 'public key file', short_name='k')

def mkpasswd(length=8, digits=2, upper=2, lower=2):
    """Create a random password

    Create a random password with the specified length and no. of
    digit, upper and lower case letters.

    :param length: Maximum no. of characters in the password
    :type length: int

    :param digits: Minimum no. of digits in the password
    :type digits: int

    :param upper: Minimum no. of upper case letters in the password
    :type upper: int

    :param lower: Minimum no. of lower case letters in the password
    :type lower: int

    :returns: A random password with the above constaints
    :rtype: str
    """

    seed(time())

    lowercase = string.lowercase.translate(None, "o")
    uppercase = string.uppercase.translate(None, "O")
    letters = "{0:s}{1:s}".format(lowercase, uppercase)

    password = list(
        chain(
            (choice(uppercase) for _ in range(upper)),
            (choice(lowercase) for _ in range(lower)),
            (choice(string.digits) for _ in range(digits)),
            (choice(letters) for _ in range((length - digits - upper - lower)))
        )
    )

    return "".join(sample(password, len(password)))

def generate_user(username, passwd=None, sshpasswd=None):
    os.system('mkdir -p roles/user/vars')
    os.system('mkdir -p roles/user/files')
    os.system('mkdir -p key')
    if not passwd:
        passwd = mkpasswd()
    if not sshpasswd:
        sshpasswd = mkpasswd()
    crypted_passwd = sha256_crypt.encrypt(passwd)
    print "passwd for user %s is: %s , ssh passwd is %s" % (username, passwd, sshpasswd)
    # generate roles/user/files/main.yml
    f = open("roles/user/vars/main.yml", "w")
    s = "newuser: %s\npasswd: %s" % (username, crypted_passwd)
    f.write(s)
    f.close()
    if FLAGS.gensshkey:
        try:
            os.remove('key/%s_id_rsa' % username)
        except:
            pass
        try:
            os.remove('key/%s_id_rsa.pub' % username)
        except:
            pass
        p = Popen(['ssh-keygen', '-N', sshpasswd, '-f', 'key/%s_id_rsa' % username], stdout=PIPE)
        out = p.communicate()[0]
        if p.returncode != 0:
            print 'ssh-key failed, %s' % out
            sys.exit(-1)
        pubkey_file = 'key/%s_id_rsa.pub' % username
    else:
        pubkey_file = FLAGS.pubkey
    # copy ssh key to roles/user/files/id_rsa.pub
    shutil.copy(pubkey_file, 'roles/user/files/id_rsa.pub')

def main():
    generate_user(FLAGS.user, FLAGS.passwd, FLAGS.sshpasswd)

if __name__ == "__main__":
    try:
        argv = FLAGS(sys.argv)[1:]  # parse flags
    except gflags.FlagsError, e:
        print '%s\\nUsage: %s ARGS\\n%s' % (e, sys.argv[0], FLAGS)
        sys.exit(1)
    main()
