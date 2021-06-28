import getopt, os, sys, urllib

SJXCOMPILE = 'http://inst.eecs.berkeley.edu/~cs164/sp07/sjxc/compile.cgi'
SKIPJAX = 'skipjax.js'

def usage ():
    print '''
Usage:

   python remote-sjxc.py FILE_PATH [-o OUTPUT_PATH]

'''
    sys.exit ()
    

opts, args = getopt.gnu_getopt (sys.argv[1:], 'o:')

outfile = sys.stdout
for opt, arg in opts:
    if opt == '-o':  outfile = open (arg, 'w')

if len (args) != 1:  usage ()
infile = args[0]


template = (open (infile)).read ()

params = urllib.urlencode({
    'template': template,
    'skipjaxlib': SKIPJAX,
});
result = urllib.urlopen(SJXCOMPILE, params)
print >>outfile, result.read()