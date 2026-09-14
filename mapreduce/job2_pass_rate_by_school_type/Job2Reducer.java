import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * Job 2 - Reducer
 * Input:  school_type \t passed   (sorted by key)
 * Output: school_type \t pass_rate_percent \t total_students
 */
public class Job2Reducer {

    private static String currentType = null;
    private static int passedCount = 0;
    private static int totalCount = 0;

    private static void emit(String schoolType, int passedN, int totalN) {
        if (totalN > 0) {
            double rate = (passedN / (double) totalN) * 100;
            System.out.printf("%s\t%.2f%%\t%d%n", schoolType, rate, totalN);
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
            String schoolType = parts[0];
            int passed = Integer.parseInt(parts[1]);

            if (schoolType.equals(currentType)) {
                passedCount += passed;
                totalCount += 1;
            } else {
                if (currentType != null) {
                    emit(currentType, passedCount, totalCount);
                }
                currentType = schoolType;
                passedCount = passed;
                totalCount = 1;
            }
        }

        if (currentType != null) {
            emit(currentType, passedCount, totalCount);
        }
    }
}
