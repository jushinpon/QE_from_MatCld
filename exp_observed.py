# Install necessary libraries if not installed
# pip install --upgrade mp_api
# pip install mp_api
# pip install mpcontribs-client

from mp_api.client import MPRester
import os
import itertools
import shutil

# Define elements for chemical combinations
elements = ["Pb","Sn","Te"]
formulas = []

# Generate all possible chemical formulas (ordered combinations)
for r in range(1, 7):
    for subset in itertools.combinations(sorted(elements), r):  # Ensure sorted order for chemsys
        formulas.append("-".join(subset))

# Ensure API Key security
API_KEY = os.getenv("MP_API_KEY", "wCMUOEdnN6nqZSmM7707B679uUkz04Zo")  # Use an environment variable if possible

# Initialize MPRester
with MPRester(API_KEY) as mpr:
    # Create a folder to store CIF files
    cif_dir = "cifs_exp"
    shutil.rmtree(cif_dir, ignore_errors=True)  # Safe removal of the directory
    os.makedirs(cif_dir, exist_ok=True)

    for formula in formulas:
        try:
            # Query Materials Project for materials matching the formula
            docs = mpr.materials.summary.search(
                chemsys=[formula],  # Use chemical system search
                theoretical=False,  # Filter for experimentally observed structures
                fields=['material_id', 'formula_pretty']
            )
        except Exception as e:
            print(f"Error querying {formula}: {str(e)}")
            continue

        for doc in docs:
            material_id = doc.material_id
            formula_pretty = doc.formula_pretty

            try:
                # Retrieve the CIF structure
                structure = mpr.get_structure_by_material_id(material_id)
                cif_path = os.path.join(cif_dir, f"{formula_pretty}_{material_id}.cif")

                # Save CIF file
                with open(cif_path, 'w') as f:
                    f.write(structure.to(fmt="cif"))

                print(f"Saved: {cif_path}")

            except Exception as e:
                print(f"Failed to retrieve CIF for {formula_pretty} ({material_id}): {str(e)}")
