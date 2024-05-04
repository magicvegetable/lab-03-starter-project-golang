class Main {
	public static void main(String[] args) {
		try {
			ProcessBuilder pb = new ProcessBuilder("./build/fizzbuzz", "serve");
			pb.redirectErrorStream(true);
			pb.redirectOutput(ProcessBuilder.Redirect.INHERIT);

			Process proc = pb.start();

			proc.waitFor();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}
