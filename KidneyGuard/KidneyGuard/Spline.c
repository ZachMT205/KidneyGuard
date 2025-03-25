#include "Spline.h"
#include <stdio.h>
#include <math.h>

static double interpolated_value(const double* m, const double* y, double x) {
    int index = (int)ceil(x + 1e-4);
    double delta_0 = x - (index - 1);
    double delta_1 = index - x;
    double term1 = m[index-1] * pow(delta_1, 3) / 6;
    double term2 = m[index] * pow(delta_0, 3) / 6;
    double term3 = (y[index-1] - m[index-1] / 6) * delta_1;
    double term4 = (y[index] - m[index] / 6) * delta_0;
    return term1 + term2 + term3 + term4;
}

static void setup_condition(const double* y, int length, double matrix[][3], double* d, double* m) {
    m[0] = 0;
    m[length - 1] = 0;
    for (int i = 1; i < length - 1; i++) {
        d[i] = 6 * (y[i + 1] - 2 * y[i] + y[i - 1]);
    }
    for (int i = 1; i < length - 1; i++) {
        matrix[i][0] = 1;
        matrix[i][1] = 4;
        matrix[i][2] = 1;
    }
}

static void solve_equation_system(int length, double matrix[][3], double* d, double* m) {
    for (int i = 1; i < length - 1; i++) {
        double factor = matrix[i + 1][0] / matrix[i][1];
        matrix[i + 1][0] -= matrix[i][1] * factor;
        matrix[i + 1][1] -= matrix[i][2] * factor;
        d[i + 1] -= d[i] * factor;
    }
    for (int i = length - 2; i > 0; i--) {
        m[i] = d[i] / matrix[i][1];
        double factor = matrix[i-1][2] / matrix[i][1];
        matrix[i - 1][2] -= matrix[i][1] * factor;
        d[i - 1] -= d[i] * factor;
    }
}

static int find_max_segment(const double* y, int length) {
    int max_loc = 0;
    double max_value = -1e10;
    for (int i = 0; i < length; i++) {
        if (y[i] > max_value) {
            max_value = y[i];
            max_loc = i;
        }
    }
    if (max_loc == 0 || max_loc == length - 1) {
        printf("ERROR: Max location at the first or the last\n");
        return -1;
    }
    return (y[max_loc - 1] > y[max_loc + 1]) ? max_loc : max_loc + 1;
}

static double find_zero_gredient(const double* m, const double* y, int index) {
    double c = m[index] / 2 + y[index] - y[index - 1] - (m[index] - m[index - 1]) / 6;
    double b = -m[index];
    double a = (m[index] - m[index - 1]) / 2;
    double bias = index - 1;
    if (fabs(a) < 1e-6) {
        return bias - c / b;
    } else {
        double delta = b * b - 4 * a * c;
        if (delta < 0) {
            printf("ERROR: equation does not have real roots\n");
            return -1e8;
        }
        double r1 = (-b + sqrt(delta)) / (2 * a);
        double r2 = (-b - sqrt(delta)) / (2 * a);
        if (r1 < 1.1 && r1 > -0.1) {
            return bias + 1 - r1;
        } else if (r2 <= 1 && r2 >= 0) {
            return bias + 1 - r2;
        } else {
            return -1e8;
        }
    }
}

double peak_refinement(const double* y, int length) {
    double m[length];
    double d[length];
    double matrix[length][3];
    setup_condition(y, length, matrix, d, m);
    solve_equation_system(length, matrix, d, m);
    int max_segment = find_max_segment(y, length);
    return find_zero_gredient(m, y, max_segment);
}

void histogram(const double* intervals, long n, double* hist_x, double* hist_v, long hist_n) {
    const int first_round_n = 100;
    double min = 80, max = 160;
    int first_histogram[first_round_n] = {0};
    double delta = (max + 0.01 - min) / first_round_n;
    for (int i = 0; i < n; i++) {
        if (intervals[i] >= min && intervals[i] < max) {
            int index = floor((intervals[i] - min) / delta);
            first_histogram[index]++;
        }
    }
    int first_round_max = 0;
    double first_round_argmax = 0;
    for (int i = 0; i < first_round_n; i++) {
        if (first_histogram[i] > first_round_max) {
            first_round_max = first_histogram[i];
            first_round_argmax = i * delta + min;
        }
    }
    double sec_min = first_round_argmax - 10;
    double sec_max = first_round_argmax + 10;
    delta = (sec_max - sec_min) / hist_n;
    for (int i = 0; i < n; i++) {
        int index = floor((intervals[i] - sec_min) / delta);
        if (index >= 0 && index < hist_n) hist_v[index]++;
        }
    for (int i = 0; i < hist_n; i++) {
        hist_x[i] = delta * i + sec_min;
    }
}

long argmax(const double* array, long n) {
    double max = -1e8;
    long loc = -1;
    for (int i = 0; i < n; i++) {
        if (array[i] > max) {
            max = array[i];
            loc = i;
        }
    }
    return loc;
}
