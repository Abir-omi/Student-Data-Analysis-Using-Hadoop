import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * Job 3 - Reducer
 * Input:  parental_involvement \t stress_level,motivation_score  (sorted by key)
 * Output: parental_involvement \t avg_stress \t avg_motivation \t student_count
 */
public class Job3Reducer {

    private static String currentKey = null;
    private static double stressSum = 0.0;
    private static double motivationSum = 0.0;
    private static int count = 0;

    private static void emit(String key, double stressTotal, double motivationTotal, int n) {
        if (n > 0) {
            System.out.printf("%s\t%.3f\t%.3f\t%d%n", key, stressTotal / n, motivationTotal / n, n);
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
            String key = parts[0];
            String[] values = parts[1].split(",");
            double stress = Double.parseDouble(values[0]);
            double motivation = Double.parseDouble(values[1]);

            if (key.equals(currentKey)) {
                stressSum += stress;
                motivationSum += motivation;
                count += 1;
            } else {
                if (currentKey != null) {
                    emit(currentKey, stressSum, motivationSum, count);
                }
                currentKey = key;
                stressSum = stress;
                motivationSum = motivation;
                count = 1;
            }
        }

        if (currentKey != null) {
            emit(currentKey, stressSum, motivationSum, count);
        }
    }
}
