
from passlib.hash import sha256_crypt
import gflags

import string
from time import time
from itertools import chain
from random import seed, choice, sample

FLAGS=gflags.FLAGS

gflags.DEFINE_boolean('gensshkey', True, 'Auto generate ssh key for user')
gflags.DEFINE_string('user', 'waijiao', 'username', short_name='u')
gflags.DEFINE_string('passwd', '', 'password, leave empty will generate random password', short_name='p')
gflags.DEFINE_string('key', '', 'public key file', short_name='k')

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

def generate_user(username, passwd=None):
    if not passwd:
        passwd = mkpasswd()
    crypted_passwd = sha256_crypt.encrypt(passwd)
    if not passwd:
        print "Auto genrated passwd for user %s is: %s" % (username, passwd)
    # generate roles/user/files/main.yml
    f = open("", "w")
    s = "newuser: %s\npasswd: %s" % (username, crypted_passwd)
    f.write(s)
    f.close()
    if FLAGS.gensshkey:
        pass
    # copy ssh key to roles/user/files/{{user}}.id_rsa.pub

def main():
    generate_user(FLAGS.user, FLAGS.passwd)

if __name__ == "__main__":
    try:
        argv = FLAGS(sys.argv)[1:]  # parse flags
    except gflags.FlagsError, e:
        print '%s\\nUsage: %s ARGS\\n%s' % (e, sys.argv[0], FLAGS)
        sys.exit(1)
    main()
