

VIEWS=$(wildcard views/*.pug)

index.html : $(VIEWS)
	pug -P -b views/ views/index.pug -o .