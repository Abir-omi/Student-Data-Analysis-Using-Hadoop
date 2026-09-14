import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * Job 1 - Mapper
 * Emits: school_region \t overall_gpa
 * Input: students.csv (comma-separated, with header row on line 1)
 */
public class Mapper {

    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String line;

        while ((line = reader.readLine()) != null) {
            line = line.trim();
            if (line.isEmpty()) {
                continue;
            }

            // Skip header row
            if (line.startsWith("student_id,")) {
                continue;
            }

            String[] fields = line.split(",", -1);
            if (fields.length < 24) {
                continue;
            }

            String schoolRegion = fields[7];
            double overallGpa;
            try {
                overallGpa = Double.parseDouble(fields[23]);
            } catch (NumberFormatException e) {
                continue;
            }

            System.out.println(schoolRegion + "\t" + overallGpa);
        }
    }
}
