function pyclean -d "Cleans folder's Python cache and pre-compiled modules"
	find . | grep -E '(__pycache__|\.pyc|\.pyo$)' | xargs rm -rf
end
