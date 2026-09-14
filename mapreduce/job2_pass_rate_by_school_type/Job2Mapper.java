import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * Job 2 - Mapper
 * Emits: school_type \t passed  (passed is 0 or 1)
 */
public class Job2Mapper {

    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String line;

        while ((line = reader.readLine()) != null) {
            line = line.trim();
            if (line.isEmpty()) {
                continue;
            }

            if (line.startsWith("student_id,")) {
                continue;
            }

            String[] fields = line.split(",", -1);
            if (fields.length < 25) {
                continue;
            }

            String schoolType = fields[6];
            String passed = fields[24];

            if (!passed.equals("0") && !passed.equals("1")) {
                continue;
            }

            System.out.println(schoolType + "\t" + passed);
        }
    }
}
