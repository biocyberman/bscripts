#!/bin/bash
#
# Author: Vang Le<vql@rn.dk>
# Created: 2016-04-10T205012+0200
# Last modified Time-stamp: <2016-05-12 14:31:12 CEST (vql)>
# Description: Convert CCDS dump to BED format

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

# CCDS dump columns, tab-separated
# chromosome(1)	nc_accession(2)	gene(3)	gene_id(4)	ccds_id(5)	ccds_status(6)
# cds_strand(7)	cds_from(8)	cds_to(9)	cds_locations(10)	match_type(11)

gawk -F'\t' '
($0 ~/^#/ || $6 !~/Public/ ){next}
{
    ec=$10 # Column 10 contains coordinates for exons
    gsub(/[\[\]]/,"", ec)
    n=split(ec, a, ", ")
    for (i=1; i <= n; i++) {
        exon=a[i]
        split(exon, startend, "-")
        # Build BED row
        rowid=$1"-"exon
        st=startend[1]
        en=startend[2]
        strand=$7
        cdsid=$5
        gene=$3
        arr[rowid]["first6"]=$1"\t"st"\t"en"\t"rowid"\t"0"\t"strand
        arr[rowid]["cdsids"][cdsid]++
        arr[rowid]["genes"][gene]++
    }
    next
}
END{
    for (r in arr){
        row=arr[r]["first6"]
        ids=""
        for (id in arr[r]["cdsids"]){
            ids=ids","id
        }
        sub(/,/, "", ids)

        gids=""
        for (gid in arr[r]["genes"]){
            gids=gids","gid
        }
        sub(/,/, "", gids)
        row=row"\t"ids"\t"gids
        print(row)
    }
}
' OFS='\t' $1|sort -k1V -k2n
