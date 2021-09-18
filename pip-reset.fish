function pip-reset -d 'Removes local Python packages, except for a few vital ones'
    pip uninstall -y (pip freeze | rg --invert-match "pip|setuptools|wheel")
end
