import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * Job 1 - Reducer
 * Input:  school_region \t overall_gpa   (sorted by key)
 * Output: school_region \t average_gpa \t student_count
 */
public class Reducer {

    private static String currentRegion = null;
    private static double gpaSum = 0.0;
    private static int count = 0;

    private static void emit(String region, double total, int n) {
        if (n > 0) {
            System.out.printf("%s\t%.3f\t%d%n", region, total / n, n);
        }
    }

    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String line;

        while ((line = reader.readLine()) != null) {
            line = line.trim();
            if (line.isEmpty()) {
                continue;
            }

            String[] parts = line.split("\t");
            String region = parts[0];
            double gpa = Double.parseDouble(parts[1]);

            if (region.equals(currentRegion)) {
                gpaSum += gpa;
                count += 1;
            } else {
                if (currentRegion != null) {
                    emit(currentRegion, gpaSum, count);
                }
                currentRegion = region;
                gpaSum = gpa;
                count = 1;
            }
        }

        if (currentRegion != null) {
            emit(currentRegion, gpaSum, count);
        }
    }
}
