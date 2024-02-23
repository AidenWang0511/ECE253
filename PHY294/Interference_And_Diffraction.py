import matplotlib.pyplot as plt
import numpy as np
from scipy.optimize import curve_fit
from pylab import loadtxt

filename="Decay Graph 275.txt"

# Define the sine curve function
def expDecay(x, A, B, C):
    return A * (np.e)**(-B*x) + C


data=loadtxt(filename, usecols=(0,1), skiprows=1, unpack=True)

SampleNum = data[0]
numCount = data[1]
error = np.sqrt(numCount)

N = len(numCount)

# Constant value and its uncertainty
constant_value = 10.9
constant_uncertainty = 0.3

# Updated numCount after subtracting the constant value
numCount_updated = numCount - constant_value

# Updated error incorporating uncertainty from the constant value
error_updated = np.sqrt(error**2 + constant_uncertainty**2)

# Now we'll use these updated values to plot the graph and calculate the new average and its uncertainty
average_numCount_updated = np.mean(numCount_updated)
std_dev_numCount_updated = np.std(numCount_updated, ddof=1)
sem_numCount_updated = std_dev_numCount_updated / np.sqrt(N)

params, covariance = curve_fit(expDecay, SampleNum, numCount_updated, maxfev=1000)
A, B, C = params
std_dev = np.sqrt(np.diag(covariance))
A_err, B_err, C_err = std_dev

x_start = min(SampleNum)
x_end = max(SampleNum)
x_vals = np.linspace(x_start - (x_end - x_start) * 0.05, x_end + (x_end - x_start) * 0.05, 100)

plt.rcParams.update({'font.size': 26})
# Plot the data and the fitted curve
plt.scatter(SampleNum, numCount_updated, color='tab:blue')
plt.plot(x_vals, expDecay(x_vals, A, B, C), lw=2, color='blue')
plt.errorbar(SampleNum, numCount, yerr=error_updated, fmt='o', color='tab:blue', ecolor='lightgrey', elinewidth=3, capsize=0)


# # Plot the updated data with the new error bars
# plt.rcParams.update({'font.size': 26})
# plt.errorbar(SampleNum, numCount_updated, yerr=error_updated, fmt='o', color='tab:red', ecolor='lightgrey', elinewidth=3, capsize=0)
plt.title("Air Sample (Collected for 120 mins) Background Subtracted")
plt.ylabel('Number of Counts')
plt.xlabel('Sample Number')
plt.show()
#
# # Print out the new average with the standard error of the mean
# print(f'Average Background Noise (Updated) = {average_numCount_updated} +/- {sem_numCount_updated}')



