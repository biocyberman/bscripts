#!/bin/bash
#
# Program name: ExtendBED.sh
# Description: Extend BED Start and End by m and n bases.
# Last modified Time-stamp: <2016-04-11 23:42:45 CEST (vql)>
# Author: Vang Le<vql@rn.dk>
# Created: 2016-04-11T23:19:01+0200

# Copyright (C) 2016  Vang Quy Le

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Usage: ExtendBED.sh -10 10 mybed.bed
#    This extend to the left 10 bases and two the right 10 bases.

bedin="$1"
bedout=${bedin/.bed/.extended.bed}
startoffset=${2:--10}
endoffset=${3:-10}

gawk -F'\t' '
($0 ~/^#/){next}
{
$2+=m;
$3+=n;
print
}
' m=$startoffset n=$endoffset OFS='\t' $bedin > $bedout
