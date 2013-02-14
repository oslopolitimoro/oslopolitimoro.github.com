# Makefile for  deploying the blogg ... the BLOGG!!!

.PHONY: deploy install clean preview

#2
# Default rule - create and install
all: install deploy
	echo all: make complete.

# 3
install:
	perl ./csv2markdown.pl -i twitter-sources.csv
	rsync -uvct *.mkd ../source/_posts/
	rm *.mkd

#Deploy the blogg to Github
deploy:
	rake generate
	rake deploy
	
# Clean
clean:
	rm *.mkd

# Preview
preview:
	rake generate
	rake preview 
