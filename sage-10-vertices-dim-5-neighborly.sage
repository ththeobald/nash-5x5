
# The single stable-set bound for dual-neighborly, simple 5-polytopes with 10 facets:

#  This file provides the SageMath code which produces the data for 
#  the article: 
#  Constantin Ickstadt, Thorsten Theobald and Bernhard von Stengel:
#  A Stable-Set Bound and Maximal Numbers of Nash Equilibria in
#  Bimatrix Games,
#  arXiv:2411.12385 

# The program uses the data on the combinatorial types of polytopes
# which was created by M. Firsching (Realizability and inscribability 
# for simplicial polytopes via nonlinear optimization, Math. Program.,
# Ser. A, vol. 166, pages 273-295 (2017),
# see file
#   neighborly10_5inscribed.txt
# on
#  https://ftp.imp.fu-berlin.de/pub/moritz/inscribe/neighborly/
# The numbering of the polytopes in that file is not consecutive
# and refers to some larger subset of underlying oriented matroids.

# The code was run under SageMath 9.2.

from sage.all import * # to run in Python3
from sage.graphs.independent_sets import IndependentSets
from fractions import Fraction

# We consider neighborly simplicial 5-polytopes with 10 vertices which are dual
# to dual-neighborly simple 5-polytopes with 10 facets
ndim = 5 
nvertices = 10  
pvertex = []
nfacets1 = 0
nfacets2 = 0
ntrials = 159375 # number of polytopes in file
myoutput = []

import re # for regular expression

# data file, each line enhanced by line numbering at the beginning of the line
with open('neighborly10_5inscribed.txt', 'r') as f:
        L = f.readlines()
L2 = [l.strip() for l in L] # list of coordinates of vertices of the polytopes

# read coordinates of one vertex of the simplicial polytope
def read_vector(str1):
	m2 = re.match(r"\[(.*)$", l2)
	if (m2 is None):
		return()
	l3 = m2.group(1)
	curvec = [];
	for k in range(ndim):
                # match rational or integer, assumes no whitespace before number
		m3 = re.match(r"(-*)(\d+)/(\d+)(. *)(.*)$", l3)
		if (m3 is not None):
			l3 = m3.group(5) 
			bnum = Integer(m3.group(2)) # converts into Sage Integer
			bdenom = Integer(m3.group(3))
			if (m3.group(1) == "-"):
				brat = - bnum / bdenom
			else:
				brat = bnum / bdenom
		else: # match integer
			m3 = re.match(r"(-*)(\d+)(. *)(.*)$", l3)
			l3 = m3.group(4) 
			bnum = Integer(m3.group(2)) # converts into Sage Integer
			if (m3.group(1) == "-"):
				brat = - bnum
			else:
				brat = bnum
		curvec.append(brat)
	pvertex.append(curvec)
	return(l3)

myoutput = []
for i in range(ntrials): # run through all polyopes in the list of indices
	pvertex = []
	l1 = L2[i]
	m1 = re.match(r"(\d+):  \[(.*)$", l1)
	if (not(m1)):
		print("Error. Line format not appropriate.")
		print(l1)
	if m1:
		l2 = m1.group(2)
		for j in range(nvertices):
			l3 = read_vector(l2)
			if (l3 is not None):
				m3 = re.match(r"(. *)(.*)$", l3)
				l2 = m3.group(2) 
		P1 = Polyhedron(vertices = pvertex) # P1 is a simplicial polytope
		nfacets1 = len(P1.Hrepresentation()) 
		P1c = P1.combinatorial_polyhedron()
		P1d = P1c.dual()
		gr = P1d.vertex_graph(); # edge graph of the simple polytope
		lis = gr.independent_set(); # returns a largest stable set
		maxstablesize = len(lis);
		singlestablebound = 2*maxstablesize;

		print("Index in file: ", m1.group(1), "Number of vertices: ", nfacets1,  ", single stable bound: ", singlestablebound);
		print("Outputline1: %2d %2d %2d" %(i, nfacets1, singlestablebound));

print("\n\n End of output of all simplicial types. \n \n");

