#!/bin/bash
clear						# make everything nice and clean
################################################
# BETTER NOTES GREPPING! 
echo "cbgrepper ALPHA"
################################################

################################################
# CONFIGURATION

# SET NOTES LOCATION
# where are your notes located?
DIR="WHEREVER_YOUR_NOTES_ARE"	# EDIT THIS!

# SET TEMP FILENAME (doesn't really matter, it gets deleted)
TEMP="tmp.txt"

# SET PREFERRED TEXT EDITOR
# (uncomment the one you want to use)
EDITOR=TextWrangler				# choose this one! it's the awesomeist
#EDITOR=TextEdit
#EDITOR=Nano
################################################
# STARTUP

# determine if the temp file exists - if so, delete it!
if [ -f $TEMP ] 				# check and see if that file exists
then
	#echo "WARNING! $TEMP already exists!"
	#echo "Deleting it now"
	rm $TEMP					# if it exists, delete it
#else 
	#echo "FYI $TEMP does not exist" # if not, let the user know.. because why not
fi
################################################
# PROMPT FOR SEARCH STRING
echo "Search:"					# print "Search:" (hopefully the user knows what to do)
read STRING						# what the user is looking for = $STRING

########################################
# GREP SWITCHES
# -i = case insensitive
# -h = don't print the filenames
# -n = add the line number
# -w = match the whole word
# --color = in color, duh
########################################

# I need to find a way to get the specific line number grep found...
DIGIT=1 						# ideally tw will go to that line..
								# right now it goes to line #1 in that file

# search for $STRING in every 
#file in the $DIR directory
								# get rid of the file paths, just keep the file names
#echo "here are the results I'm writing to $TEMP"
# grep -irnw --color $STRING $DIR/* | sed "s/.*\///"							
grep -irnw --color $STRING $DIR/* | sed "s/.*\///" > $TEMP

### NOTE: seems to have trouble when there is a "/" after the search string

# print the results, displaying line numbers
#nl $TEMP						# this will show user output
cat -n $TEMP					# show to tmp.txt, numbered by line << BETTER

# TELL THE USER HOW MANY RESULTS WERE FOUND
# this just lists how many lines there are in the temp file
COUNT=$(cat tmp.txt | wc -l)

# if occurrences of $STRING are 0, then say "sorry no results"
# else keep going

if [[ $COUNT =~ "0" ]]; then
	echo "Sorry, no results."
else
	echo ">>>> $COUNT occurrences of $STRING found"
		          # i.e.   189 occurrences of mesa found

# prompt the user to choose a line number
echo "Which one would you like to see? (enter a number)"
read NUMBER

# cut the text on each line after the ":"
# 			REMEMBER!! >> means annotate, > means replace
cut -f1 -d":" $TEMP > tmp2.txt

# WHAT WE WANT in the tmp file now is just the line numbers!
# 	cut -c 6-7 new3
#	that cuts everything but the 6th and 7th characters of e/line in the file new3
# here are what the lines look like in our tmp:
# 2012-08-22_notes.txt:161:
# 123456789112345678921 < first 21 characters
# cut -c 22-24 tmp.txt

# HOW TO PRINT A SPECIFIC LINE FROM A TEXT FILE:
# sed -n 1p tmp.txt
# that will print the whole first line of the file tmp.txt

# print the line number the user previously entered
echo "Opening the file:"

# print whatever is on that line
sed -n "$NUMBER"p tmp2.txt
FILE=$(sed -n "$NUMBER"p tmp2.txt)

################################################
#THIS WHOLE SECTION IS OPTIONAL
# echo "NOTE: Your preferred text editor is $EDITOR"
# echo "If that's ok with you, hit y. If not, hit n"
# read RESPONSE
# 
# 	# if the user said y, then just proceed
# 	if [[ $RESPONSE =~ "y" ]]; then
# 		echo "continuing with the editor you selected in the script..."
# 	# if they said n, ask them to choose an editor
# 	else
# 		echo "Choose one: 1) TextWrangler 2) TextEdit 3) Nano"
# 		read CHOICE
# 	fi
# 
# 	# NOTE: if they said y above, these if/thens don't do anything
# 	
# 	if [[ $CHOICE =~ "1" ]]; then
# 		EDITOR=TextWrangler
# 	fi
# 	
# 	if [[ $CHOICE =~ "2" ]]; then
# 	EDITOR=TextEdit
# 	fi
# 	
# 	if [[ $CHOICE =~ "3" ]]; then
# 	EDITOR=Nano
# 	fi
#END OPTIONAL SECTION	
################################################


if [[ $EDITOR =~ "TextWrangler" ]]; then
	edit $DIR/$FILE
fi

if [[ $EDITOR =~ "TextEdit" ]]; then
	open -a TextEdit.app $DIR/$FILE
fi

if [[ $EDITOR =~ "Nano" ]]; then
	nano $DIR/$FILE
fi

# APPLESCRIPT
return=`/usr/bin/osascript << EOT
tell app "TextWrangler"
	activate								# open up TextWrangler
	select line $DIGIT of project window 1	# go to line $DIGIT
end tell                         
EOT`

################################################
# CLEANUP

# clean up $TEMP file
if [ -f $TEMP ] 				# check and see if that file exists
then
	rm $TEMP					# if it exists, delete it
fi

# clean up tmp2.txt
if [ -f tmp2.txt ] 				# check and see if that file exists
then
	rm tmp2.txt					# if it exists, delete it
fi
################################################

# the end
fi
