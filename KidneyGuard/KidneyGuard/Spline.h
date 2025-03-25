#ifndef SPLINE_H
#define SPLINE_H

double peak_refinement(const double* y, int length);
void histogram(const double* intervals, long n, double* hist_x, double* hist_v, long hist_n);
long argmax(const double* array, long n);

#endif /* SPLINE_H */
