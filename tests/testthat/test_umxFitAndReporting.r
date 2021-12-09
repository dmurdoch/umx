# library(testthat)
# library(umx)
# test_file("~/bin/umx/tests/testthat/test_umxFitAndReporting.r") 
# test_package("umx")

context("umxFitAndReporting_Functions")

test_that("umxDiagnose works", {
	require(umx)
	data(demoOneFactor)
	manifests = names(demoOneFactor)

	m1 = umxRAM("One Factor", data = demoOneFactor, type = "cov",
		umxPath("G", to = manifests),
		umxPath(var = manifests),
		umxPath(var = "G", fixedAt = 1)
	)

	umxDiagnose(m1)
})

test_that("umxExpCov works", {
	require(umx)
	data(demoOneFactor)
	manifests = names(demoOneFactor)

	m1 = umxRAM("One Factor", data = demoOneFactor, type = "cov",
		umxPath("G", to = manifests),
		umxPath(var = manifests),
		umxPath(var = "G", fixedAt = 1)
	)
	vcov(m1) # supplied by OpenMx
	umxExpCov(m1, digits = 3)
})

test_that("umxExpMeans works", {
	require(umx)
	data(demoOneFactor)
	manifests = names(demoOneFactor)
	
	m1 = umxRAM("One Factor", data = demoOneFactor,
		umxPath("G", to = manifests),
		umxPath(var = manifests),
		umxPath(var = "G", fixedAt = 1)
	)
	
	umxExpMeans(m1)
	umxExpMeans(m1, digits = 3)
})

test_that("RMSEA works", {
	data(demoOneFactor)
	manifests = names(demoOneFactor)
	
	m1 = umxRAM("One Factor", data = demoOneFactor, type= "cov",
		umxPath("G", to = manifests),
		umxPath(var = manifests),
		umxPath(var = "G", fixedAt = 1.0)
	)
	tmp = summary(m1)
	RMSEA(tmp)
})