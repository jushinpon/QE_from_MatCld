#pip install mp_api
#pip install mpcontribs-client
from mp_api.client import MPRester
import os
import itertools

elements = ["W","Te"]
formulas = []

# 生成所有可能的化學式
for r in range(1, 7):
    for subset in itertools.combinations(elements, r):
        formulas.append("-".join(subset))

with MPRester("wCMUOEdnN6nqZSmM7707B679uUkz04Zo") as mpr:
    for formula in formulas:
        try:
            #docs = mpr.summary.search(
            docs = mpr.materials.summary.search(
                chemsys=[formula],
                fields=['material_id', 'formula_pretty']
            )
        except Exception as e:
            print(f"無法查詢 {formula} 的結果，錯誤訊息：{str(e)}")
            continue

        # 建立一個名為 'cifs' 的資料夾來儲存 CIF 檔案
        if not os.path.exists('cifs'):
            os.makedirs('cifs')

        for doc in docs:
            material_id = doc.material_id
            formula_pretty = doc.formula_pretty
            # 下載 CIF 檔案
            cif_data = mpr.get_structure_by_material_id(material_id, conventional_unit_cell=True)
            # 將 CIF 檔案寫入到 'cifs' 資料夾中
            with open(f'cifs/{formula_pretty}_{material_id}.cif', 'w') as f:
                f.write(cif_data.to(fmt="cif"))
