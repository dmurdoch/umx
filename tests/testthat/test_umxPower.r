# library(testthat)
# library(umx)
# test_file("~/bin/umx/tests/testthat/test_umxPower.r") 
# test_package("umx")

context("umxCompare()")

test_that("umxPower works", {
	# ===================================================
	# = Power to detect correlation of .3 in 200 people =
	# ===================================================
	
	# 1 Make some data
	tmp = umx_make_raw_from_cov(qm(1, .3| .3, 1), n=2000, varNames= c("X", "Y"), empirical= TRUE)
	
	# 2. Make model of true XY correlation of .3
	m1 = umxRAM("corXY", data = tmp,
	   umxPath("X", with = "Y"),
	   umxPath(var = c("X", "Y"))
	)
	# 3. Test power to detect .3 versus 0, with n= 90 subjects
	umxPower(m1, "X_with_Y", n= 90)
	
	# ####################
	# # Estimating power #
	# ####################
	#    method = ncp
	#         n = 90
	#     power = 0.83
	# sig.level = 0.05
	# statistic = LRT
	
	# =================================================
	# = Tabulate Power across a range of values of  n =
	# =================================================
	umxPower(m1, "X_with_Y", explore = TRUE)
	
	# Explore power across N with r @ .3
	umxPower(m1, "X_with_Y", explore = TRUE)

	# Test using cor.test doing the same thing.
	pwr::pwr.r.test(r = .3, n = 90)
	#           n = 90
	#           r = 0.3
	#   sig.level = 0.05
	#       power = 0.827
	# alternative = two.sided

	# =====================================
	# = Examples with method = empirical  =
	# =====================================
	
	# Power to detect r = .3 given n = 90
	# takes a minute
	umxPower(m1, "X_with_Y", n = 90, method = "empirical", explore = FALSE)
	# power is .823

	
	# Power search for detectable effect size, given n = 90
	expect_error(
		umxPower(m1, "X_with_Y", n= 90, explore = TRUE),
		regex = "'ncp' does not work for both explore AND fixed n"
	)
	# takes a minute or two!
	# umxPower(m1, "X_with_Y", n= 90, method = "empirical", explore = TRUE)
	
	data(twinData) # ?twinData from Australian twins.
	twinData[, c("ht1", "ht2")] = 10 * twinData[, c("ht1", "ht2")]
	mzData = twinData[twinData$zygosity %in% "MZFF", ]
	dzData = twinData[twinData$zygosity %in% "DZFF", ]
	m1 = umxACE(selDVs = "ht", selCovs = "age", sep = "", dzData = dzData, mzData = mzData)
	
	# Drop more than 1 path
	umxPower(m1, update = c("c_r1c1", "age_b_Var1"), method = 'ncp', n=90, explore = FALSE)
	expect_error(
		# Specify only 1 parameter (not 'age_b_Var1' and 'c_r1c1' ) to search a parameter:power relationship
		umxPower(m1, update = c("c_r1c1", "age_b_Var1"), method = 'empirical', n=90, explore = TRUE),
		regex = "fixed n only works for updates of 1 parameter"
	)

	# note: Can't use method = "ncp" with search)
	expect_error(umxPower(m1, update = c("c_r1c1"), method = 'empirical', n=90, explore = TRUE), "Cannot generate data with trueModel 'ACE'")
})
