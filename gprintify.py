#!/usr/bin/python
#---------------------------------------------------------------
# Project         : Mandrake Linux
# Module          : spec-helper
# File            : gprintify.py
# Version         : $Id$
# Author          : Frederic Lepied
# Created On      : Tue Feb  6 18:39:14 2001
# Purpose         : rewrite "bla $TOTO bla" in "bla %s bla" $TOTO
#                   in echo/failure/success/passed/daemon/action
#                   and replqce echo by gprintf.
#---------------------------------------------------------------

import sys
import re

echo_regex=re.compile('^(.*)echo +(-[en]+)?')
string_regex=re.compile('^([^"]*?)\$?"([^"]*[^\\\\])"([^>\|\[\]]*|.*\|\|.*)$')
var_regex=re.compile('(?<!\\\)(\$[a-zA-Z0-9_{}]+(?:\[\$[a-zA-Z0-9_{}]+\])?}?)')
init_func_regex=re.compile('(.*(action|success|failure|passed)\s*.*)')

def process_start(start):
    res=echo_regex.findall(start)
    if res:
        if 'n' in res[0][1]:
            return [res[0][0] + 'gprintf "', '"', '']
        else:
            return [res[0][0] + 'gprintf "', '\\n"', '']
    res=init_func_regex.search(start)
    if res:
        return [res.group(0) + '"', '"', '']
    return None

def process_vars(str, trail):
    var_res=var_regex.findall(str)
    if var_res:
        ret=var_regex.sub('%s', str) + trail
        for v in var_res:
            ret = ret + ' "' + v + '"'
        return ret
    else:
        return str + trail

def process_line(line):
    res=string_regex.findall(line)
    if res: 
        res=res[0]
        start=process_start(res[0])
        if not start:
            return line
        str=process_vars(res[1], start[1])
        if res[2][-1] == "\n":
            end = res[2][:-1]
        else:
            end=res[2]
        final=start[0] + str + start[2]

        res=string_regex.findall(end)
        if res:
            res=res[0]
            start=process_start(res[0])
            if not start:
                return final + end + '\n'
            str=process_vars(res[1], start[1])
            end=res[2]
            return final + start[0] + str + start[2] + end + '\n'
        else:
            return final + end + '\n'
    else:
        return line

def process_file(filename):
    fd=open(filename, 'r')
    lines=fd.readlines()
    fd.close()

    fd=open(filename, 'w')
    for l in lines:
        fd.write(process_line(l))
    fd.close()
    
def main(args):
    for f in args:
        process_file(f)

if __name__ == '__main__':
    main(sys.argv[1:])

# gprintify.py ends here
