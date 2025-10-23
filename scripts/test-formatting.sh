#!/bin/bash

echo "Testing JavaScript formatting with 4-space tabs..."
echo -e "const obj = {\n  prop1: 'value1',\n    prop2: 'value2'\n};" > /tmp/js-test.js
echo "Before formatting:"
cat /tmp/js-test.js

echo -e "\nAfter formatting with our configuration:"
nvim --headless -u ~/.config/nvim/init.lua /tmp/js-test.js -c ':lua require("conform").format()' -c ':w' -c 'qa!' 2>/dev/null
cat /tmp/js-test.js

echo -e "\n\nTesting HTML formatting with 2-space tabs..."
echo -e "<div>\n  <p>test</p>\n  <span>another</span>\n</div>" > /tmp/html-test.html
echo "Before formatting:"
cat /tmp/html-test.html

echo -e "\nAfter formatting with our configuration:"
nvim --headless -u ~/.config/nvim/init.lua /tmp/html-test.html -c ':lua require("conform").format()' -c ':w' -c 'qa!' 2>/dev/null
cat /tmp/html-test.html

echo -e "\n\nTest completed!"