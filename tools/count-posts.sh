#!/bin/bash
ls -1 ../source/_posts/2* | awk -F '-' '{ print $1 $2 }' | uniq --count
