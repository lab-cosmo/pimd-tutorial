#!/bin/bash

git clean -dxn

echo "WARNING. This command will reset the tutorial to pristine state."
echo "Press CTRL+C to abort"
read

git clean -dfx
