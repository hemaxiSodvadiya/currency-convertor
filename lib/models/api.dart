class Post {

  final String base_code;
  final String rates;
  final int code;

  Post(
      {
        required this.base_code,
        required this.rates,required this.code});

  factory Post.fromJSON({required Map<String, dynamic> json}) {
    return Post(
        base_code: json['base_code'],
        rates: json['rates'],
        code: json['time_eol_unix'],
    );
  }
}
