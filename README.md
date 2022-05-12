<h1>Numerical Integration</h1>

Compares the results of the __trapezoid method__ with a simple summation.

<img src = "./files for README/trapz_doc_from_MATLAB - Copy.png" width = "700"/>

For ___N+1___ evenly spaced data points, the definite integral can be approximated by:

<img src = "./files for README/definition.png" width = "450"/>

Here ```(b-a)/N``` is the spacing between data points.


Note that this equates to a simple summation multiplied by the data point spacing, minus a __correction term__: <br> ```( f(1) + f(end) )/2 ```

If the spacing between the data points is not constant, the formula generalizes to:

<img src = "./files for README/definition w_unequal spacing.png" width = "500"/>


**Resources:**

https://www.mathworks.com/help/matlab/ref/trapz.html

__Sample output:__

<img src = "./files for README/sample_from_MATLAB.png" width = "800"/>
