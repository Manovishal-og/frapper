import 'dart:convert';
import 'dart:io'; // Add this line at the top
import 'package:http/http.dart' as http; // Add this line

const version = '0.0.1'; // Add this line

void main(List<String> arguments) {
	if (arguments.isEmpty || arguments.first == 'help') {
		printUsage(); // Change this from 'Hello, Dart!'
	}
	else if (arguments.first == 'version') {
		print('Frapper CLI version $version');
	} 
	else if (arguments.first == 'search') {
		final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
		searchWikipedia(inputArgs);
	}
	else {
		printUsage(); // Catch-all for any unrecognized command.
	}
}

Future<String> wikipediaInfo(String article) async{
	final uri = Uri.https(    'en.wikipedia.org', // Wikipedia API domain
		'/api/rest_v1/page/summary/$article',
	);

	final response = await http.get(uri);

	if(response.statusCode == 200){
		return response.body;
	}

	return 'Error: Failed to Fetch Search term $article.Status code: ${response.statusCode}';
}

void searchWikipedia(List<String>? arguments) async { // Add this new function and add ? to arguments type
	final String articleTitle;

	if(arguments == null || arguments.isEmpty){
		print("Enter the Search term :");
		articleTitle = stdin.readLineSync() ?? '';
		if(articleTitle == null || articleTitle.isEmpty){
			print("Enter the Search term :  ");
			return;
		}
	}


	else{
		articleTitle = arguments.join(' ');
	}

	print("Looking for your search result  $articleTitle");
	var article = await wikipediaInfo(articleTitle);

	final data = jsonDecode(article);

	print("\nTitle: ${data['title']}");
	print("Description: ${data['description']}");
	print("\nSummary:\n${data['extract']}\n");


}

void printUsage() { // Add this new function
	print(
		"The following commands are valid: 'help', 'version', 'search <ARTICLE-TITLE>'"
	);
}

