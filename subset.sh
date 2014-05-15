#!/bin/sh
# This program runs the SubsetHapMap plugin in TASSEL 4 according to user modfied parameters
# generates a log file and packages the hapmap files, log file, name list and release notes
# into a zip archve for distribution RJE 20120824

#    		Copyright 2012 Robert J. Elshire
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

########
# This program depends on TASSEL 4, md5sum and zip
########

########
# User Modified Parameters
########

######## Meta Information

PROJECT="Rebecca" # PI  or Project NAME
STAGE="UNFILTERED" #UNFILTERED / MERGEDUPSNPS / HAPMAPFILTERED / BPEC / IMPUTED
BUILD="All_Ryegrass_PSTI_Testing" #Build Designation
BUILDSTAGE="0.9_RC-1" #this is RC-# or FINAL

####### File Locations

TASSELFOLDER="/home/elshirer/tassel4/tassel4.0_standalone" # Where the TASSEL4 run_pipeline.pl resides
INPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/elshirer/06_HapMap/01_UnfilteredSNPs" # Where the input hapmap files reside
INPUTBASENAME="elshirer_UNFILTERED_All_Ryegrass_PSTI_Testing_0.9_RC-1_chr" # Base name of input files. This precedes $CHRM.hmp.txt.gz
#INPUTBASENAME="AllTaxa_IMPUTED_AllZea_GBS_Build_July_2012_FINAL_chr" # Base name of input files. This precedes $CHRM.hmp.txt.gz
TAXALIST="/dataset/semihybrid_ryegrass_GBS/active/elshirer/50_KeyFiles/Rebecca_allplate_correct_keyfile_14MAY14_subsetlist.txt"
OUTPUTFOLDER="/dataset/semihybrid_ryegrass_GBS/active/elshirer/54_Subset/Rebecca" # Where output of script should go
KEYFILE="/dataset/semihybrid_ryegrass_GBS/active/elshirer/50_KeyFiles/Rebecca_allplate_correct_keyfile_14MAY14.txt"
RELEASENOTES="" # Release Notes to include in distribution.
MINALLELES="1" # Minimum number of alleles needed for SNPs to be extracted. 0 is default

######## TASSEL Options
module load tassel/4
MINRAM="-Xms512m" # Minimum RAM for Java Machine
MAXRRAM="-Xmx10g" # Maximum RAM for Java Machine
STARTCHRM="1" # Chromosome to start with
ENDCHRM="13" # Chromosome to end with

########
# Variables used by script
#######

DATE=$(date +%Y%m%d) #Date from system in the format YYYYMMDD
CHRM="1" # This is used in looping in the body of the program
CHRME="1"  # This is used in looping in the body of the program

########
# Generate the XML Files for each chromosome to run this process
########

CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))
while [ $CHRM -lt $CHRME ]; do
  echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' > "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_chr"$CHRM".xml
  echo ' <TasselPipeline>' >> "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_chr"$CHRM".xml
  echo '    <fork1>' >> "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_chr"$CHRM".xml
  echo '        <ExtractHapmapSubsetPlugin>' >> "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_chr"$CHRM".xml
  echo '            <h>'$INPUTFOLDER'/'$INPUTBASENAME''$CHRM'.hmp.txt.gz</h>' >> "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_chr"$CHRM".xml 
  echo '            <o>'$OUTPUTFOLDER'/'$PROJECT'_'$STAGE'_'$BUILD'_'$BUILDSTAGE'_chr'$CHRM'.hmp.txt.gz</o>' >> "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_chr"$CHRM".xml
  echo '            <p>'$TAXALIST'</p>' >> "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_chr"$CHRM".xml
  echo '            <a>'$MINALLELES'</a>' >> "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_chr"$CHRM".xml
  echo '        </ExtractHapmapSubsetPlugin>' >> "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_chr"$CHRM".xml
  echo '    </fork1>' >> "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_chr"$CHRM".xml
  echo '    <runfork1/>' >> "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_chr"$CHRM".xml
  echo '</TasselPipeline>' >> "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_chr"$CHRM".xml
  CHRM=$((CHRM+1))
done

###########
# Record files used in run_pipeline
###########

date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
echo "Name of Machine Script is running on:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
hostname | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
echo "Files available for this run:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))
while [ $CHRM -lt $CHRME ]; do
  ls -1 "$INPUTFOLDER"/"$INPUTBASENAME""$CHRM."hmp.txt.gz | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
  CHRM=$((CHRM+1))
done
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
echo "MD5SUM of files used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))
while [ $CHRM -lt $CHRME ]; do
 # md5sum "$INPUTFOLDER"/"$INPUTBASENAME""$CHRM."hmp.txt.gz | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
  CHRM=$((CHRM+1))
done
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
echo "md5sum of tassel jar file:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
md5sum "$TASSELFOLDER"/sTASSEL.jar | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log

######## For Each chromosome put the contents of the XML files into the log

CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))
while [ $CHRM -lt $CHRME ]; do
  echo "Contents of the XML file for chromosome $CHRM used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
  echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
  cat $OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_chr"$CHRM".xml" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
  echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
  CHRM=$((CHRM+1))
done

echo "Contents of the the shell script used to run pipeline:" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
cat "$0" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log 
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
echo "" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
echo "Starting Pipeline" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
echo "" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log

#######
# Run TASSEL for each chromosome
#######

CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))
while [ $CHRM -lt $CHRME ]; do
  date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
  echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
  #Run tassel pipeline, redirect stderr to stdout, copy stdout to log file.
  run_pipeline.pl  "$MINRRAM" "$MAXRRAM" -configFile "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_chr"$CHRM".xml 2>&1 | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
  date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
  CHRM=$((CHRM+1))
done
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
echo "End of Pipeline" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log

########
# Record md5sums of output files in log
########

echo "md5sum of hapmap File" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))
while [ $CHRM -lt $CHRME ]; do
  md5sum "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$BUILD"_"$BUILDSTAGE"_chr"$CHRM".hmp.txt.gz | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
  CHRM=$((CHRM+1))
done

echo "*******" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
date | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log

########
# Create zip archive of hapmap files, log, name list and release notes
########


CHRM=$STARTCHRM
CHRME=$((ENDCHRM+1))
while [ $CHRM -lt $CHRME ]; do
  zip -j "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$BUILD"_"$BUILDSTAGE"_"$DATE".zip "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$BUILD"_"$BUILDSTAGE"_chr"$CHRM".hmp.txt.gz | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
  CHRM=$((CHRM+1))
done
# Add Taxa List and Release Notes to Zip Archive
zip -j "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$BUILD"_"$BUILDSTAGE"_"$DATE".zip "$TAXALIST" "$RELEASENOTES" "$KEYFILE" | tee -a "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
# Add Log file To Zip Archive
zip -j "$OUTPUTFOLDER"/"$PROJECT"_"$STAGE"_"$BUILD"_"$BUILDSTAGE"_"$DATE".zip "$OUTPUTFOLDER"/"$PROJECT"_SubsetHapMap_"$DATE".log
