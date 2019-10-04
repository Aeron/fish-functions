function pyclean -d "Cleans directory Python cache and pre-compiled modules"
	find . | grep -E '(__pycache__|\.pyc|\.pyo$)' | xargs rm -rf
end
