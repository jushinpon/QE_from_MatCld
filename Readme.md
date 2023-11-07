Materials Project script
1. install anaconda
2. choose "Command Prompt" for your terminal
3. "conda install pip" to install pip
4. pip install mp_api
5. pip install mpcontribs-client

You will get all cif files in cifs folder


****Step 1. get all cif files using mp_get_cif.py

    You need to modify the following for your own system. For example,

elements = ["V", "Co", "Cr", "Cu", "Fe","Ni"]

# 生成所有可能的化學式
for r in range(1, 7):

****Step 2. get all cif files using mp_get_cif.py