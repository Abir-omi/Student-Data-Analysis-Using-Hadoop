import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * Job 3 - Mapper
 * Emits: parental_involvement \t stress_level,motivation_score
 */
public class Job3Mapper {

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
            if (fields.length < 19) {
                continue;
            }

            String parentalInvolvement = fields[13];
            double stressLevel;
            double motivationScore;
            try {
                stressLevel = Double.parseDouble(fields[17]);
                motivationScore = Double.parseDouble(fields[18]);
            } catch (NumberFormatException e) {
                continue;
            }

            System.out.println(parentalInvolvement + "\t" + stressLevel + "," + motivationScore);
        }
    }
}
