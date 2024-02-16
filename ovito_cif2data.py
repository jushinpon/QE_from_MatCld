#pip install -U ovito
import warnings
warnings.filterwarnings('ignore', message='.*OVITO.*PyPI')
from ovito.io import import_file, export_file
from ovito.modifiers import ReplicateModifier
from ovito.pipeline import StaticSource,Pipeline 
import sys

# Load the structure from a CIF file
pipeline = import_file("input.cif")

# Compute and inspect the total number of atoms
data = pipeline.compute()
total_atoms = len(data.particles.positions)

# Check if the total number of atoms is fewer than 4
if total_atoms < 4:
    # If yes, apply the replicate modifier to create a 2x2x2 supercell
    replicate_modifier = ReplicateModifier()
    replicate_modifier.num_x = 2
    replicate_modifier.num_y = 2
    replicate_modifier.num_z = 2
    pipeline.modifiers.append(replicate_modifier)
    #print("Applied replication modifier due to fewer than 4 atoms.")
#else:
#    # Otherwise, do not apply the replicate modifier
#    print("No replication modifier applied, more than or equal to 4 atoms present.")

# Export the (possibly modified) structure to a LAMMPS data file
export_file(pipeline, "output.data", "lammps/data")
