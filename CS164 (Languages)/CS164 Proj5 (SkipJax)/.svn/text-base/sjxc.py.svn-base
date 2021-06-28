import getopt, os, sys
import skipjax, util


def main (args):
    try:
        outputDir, files, libpath = parseArgs (args)
    except IOError, e:
        util.error (e)
    except:
        usage ()

    try:
        for f in files:
            name, ext = os.path.splitext (os.path.basename (f))
            if ext in ('.js',):
                outFile = '%s/%s.js'% (outputDir, name)
                skipjax.compileJavaScriptFile (f, outFile)
            elif ext in ('.sjx',):
                outFile = '%s/%s.js'% (outputDir, name)
                skipjax.compileSkipjaxFile (f, outFile)
            elif ext in ('.html', '.htm', '.tem'):
                outFile = '%s/%s.html'% (outputDir, name)
                skipjax.compileTemplateFile (f, outFile, libpath)
            else:
                util.error ('Unknown file extension "%s"'% (ext))
    except Exception, e:
        util.error ('Error compiling "%s": %s'% (outFile, e))


def parseArgs (args):
    outputDir, files, libpath = './', [], 'skipjax.js'
    try:
        opts, args = getopt.gnu_getopt (args, 'hl:o:')
    except GetoptError:
        usage ()

    for opt, arg in opts:
        if opt == '-h':
            raise Exception
        elif opt == '-l':
            libpath = arg
        elif opt == '-o':
            if not (os.path.isdir (arg) and os.access (arg, os.W_OK)):
                raise IOError, 'Invalid directory "%s"'% (arg)
            outputDir = arg

    for arg in args:
        if not (os.path.isfile (arg) and os.access (arg, os.R_OK)):
            raise IOError, 'Invalid file "%s"'% (arg)
        files.append (arg)

    if len (files) == 0:
        raise StandardError, 'Need at least one file to compile.'

    return outputDir, files, libpath


def usage ():
    print '''
Usage:

    python sjxc.py FILE+ [-o OUTPUT_DIR] [-l PATH_TO_SKIPJAX_LIB]
    python sjxc.py -h

OUTPUT_DIR defaults to the working directory.
PATH_TO_SKIPJAX_LIB defaults to "skipjax.js."

'''
    sys.exit (1)


if __name__ != '__main__':
    raise RuntimeError, "This is not a module; don't import it."

main (sys.argv[1:])
