#!/bin/bash

parent_dir="/media/meurvill/Elements/re-do_V2/02_BNN/run_5_5"

# Loop over child folders CV0 to CV9
for i in {0..9}; do
    child_dir="${parent_dir}/CV${i}"
    gnome-terminal --tab --working-directory="${child_dir}" --title="CV${i}" -- sh -c "python3 'bnn_classify.py' ; bash"
done

