import matplotlib.pyplot as plt
import numpy as np
from scipy.optimize import curve_fit
from pylab import loadtxt

filename="Background_week2.txt"

# Define the sine curve function
def sine_curve(x, A, B, C):
    return A * np.sinc(B * x) + C

# Get your data
#v, v_err, i, i_err, title = get_data_2()
#i = [i[j] / 1000 for j in range(len(i))]
#i_err = [i_err[j] / 1000 for j in range(len(i_err))]

data=loadtxt(filename, usecols=(0,1), skiprows=1, unpack=True)

SampleNum = data[0]
numCount = data[1]
error = np.sqrt(numCount)




# Use curve_fit to fit the sine curve to your data

#params, covariance = curve_fit(sine_curve, postition, intensity)

# Extract the parameter values and their uncertainties from the covariance matrix
#A, B, C = params
#std_dev = np.sqrt(np.diag(covariance))
#A_err, B_err, C_err = std_dev

# Generate x values for plotting
#x_start = min(postition)
#x_end = max(postition)
#x_vals = np.linspace(x_start - (x_end - x_start) * 0.05, x_end + (x_end - x_start) * 0.05, 1000)

plt.rcParams.update({'font.size': 26})
# Plot the data and the fitted curve
plt.errorbar(SampleNum, numCount, yerr=error, fmt='o', color='tab:blue', ecolor='lightgrey', elinewidth=3, capsize=0)
#plt.plot(voltage, numCount, lw=2, color='blue')


plt.title("Background Noise (Collected for 60 mins)")
plt.ylabel('Number of Counts')
plt.xlabel('Sample Number')

plt.show()

# Average of numCount
average_numCount = np.mean(numCount)

# Standard deviation of numCount
std_dev_numCount = np.std(numCount, ddof=1)  # Using Bessel's correction

# Number of observations
N = len(numCount)

# Standard error of the mean (SEM)
sem_numCount = std_dev_numCount / np.sqrt(N)

print(f'Average Background Noise = {average_numCount} +/- {sem_numCount}')

# print(f'A = {A} +/- {A_err}')
# print(f'B = {B} +/- {B_err}')
# print(f'C = {C} +/- {C_err}')
