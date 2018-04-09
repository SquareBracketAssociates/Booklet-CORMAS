# A booklet on the CORMAS multi-agent simulation framework

[![Build Status](https://travis-ci.org/cormas/Booklet-CORMAS.svg?branch=master)](https://travis-ci.org/cormas/Booklet-CORMAS)

## Install pillar on our computer
Most of the information about pillar are available [here](https://ci.inria.fr/pharo-contribution/job/EnterprisePharoBook/lastSuccessfulBuild/artifact/book-result/PillarChap/Pillar.pdf). But we provide there a quick stater quite in order to compile in PDF/html the book source code.

### Install for Linux users
Those command line will download a pharo distribution maid for pillar.

    wget https://raw.githubusercontent.com/pillar-markup/pillar/master/download.sh
    chmod +x download.sh
    ./download.sh

## Compilation from sources

## Cheatsheets
information from [html](https://ci.inria.fr/pharo-contribution/job/EnterprisePharoBook/lastSuccessfulBuild/artifact/book-result/PillarChap/Pillar.html). Pillar is a maked language as markdown.

### Chapters & Sections
A line starting with `!` represents a heading. Use multiple `!` to create sections and subsections.

### Paragraphs and Framed Paragraphs

An empty line starts a new paragraph.

An annotated paragraph starts with `@@` followed by a keyword such as `todo` and `note`. For example,

    @@note this is a note annotation.

### Formatting

* To make something bold, write `""bold""` (with 2 double quotes)
* To make something italic, write `''italic''` (with 2 single quotes)
* To make something monospaced, write `==monospaced==`
* To make something strikethrough, write `--strikethrough--`
* To make something subscript, write `@@subscript@@`
* To make something superscript, write `^^superscript^^`
* To make something underlined, write `__underlined__`

### Unordered Lists
Bullet point :

    -A block of lines,
    -where each line starts with ==-==
    -is transformed to a bulleted list

generate

* A block of lines,
* where each line starts with `==-==`
* is transformed to a bulleted list

### Ordered Lists

    #A block of lines,
    #where each line starts with ==#==
    #is transformed to an ordered list

for

1. A block of lines,
2. where each line starts with `==#==`
3. is transformed to an ordered list

### Introduce code

    [[[label=script1|caption=My script that works|language=smalltalk
    self foo bar
    ]]]
