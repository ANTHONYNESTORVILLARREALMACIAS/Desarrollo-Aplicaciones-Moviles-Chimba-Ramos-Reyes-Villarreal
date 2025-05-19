import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/login_controller.dart';
import '../themes/text_styles.dart';
import '../themes/button_styles.dart';

// Ecuadorian city, province, and postal code mapping (expanded)
const Map<String, Map<String, String>> ecuadorRegions = {
  'Quito': {'province': 'Pichincha', 'postalCode': '1701'},
  'Guayaquil': {'province': 'Guayas', 'postalCode': '0901'},
  'Cuenca': {'province': 'Azuay', 'postalCode': '0101'},
  'Ambato': {'province': 'Tungurahua', 'postalCode': '1801'},
  'Loja': {'province': 'Loja', 'postalCode': '1101'},
  'Machala': {'province': 'El Oro', 'postalCode': '0701'},
  'Portoviejo': {'province': 'Manabí', 'postalCode': '1301'},
  'Manta': {'province': 'Manabí', 'postalCode': '1308'},
  'Esmeraldas': {'province': 'Esmeraldas', 'postalCode': '0801'},
  'Ibarra': {'province': 'Imbabura', 'postalCode': '1001'},
  'Riobamba': {'province': 'Chimborazo', 'postalCode': '0601'},
  'Latacunga': {'province': 'Cotopaxi', 'postalCode': '0501'},
  'Tulcan': {'province': 'Carchi', 'postalCode': '0401'},
  'Santo Domingo': {'province': 'Santo Domingo de los Tsáchilas', 'postalCode': '2301'},
  'Babahoyo': {'province': 'Los Ríos', 'postalCode': '1201'},
  'Quevedo': {'province': 'Los Ríos', 'postalCode': '1205'},
  'Milagro': {'province': 'Guayas', 'postalCode': '0910'},
  'Durán': {'province': 'Guayas', 'postalCode': '0902'},
  'Puyo': {'province': 'Pastaza', 'postalCode': '1601'},
  'Tena': {'province': 'Napo', 'postalCode': '1501'},
  'Macas': {'province': 'Morona Santiago', 'postalCode': '1401'},
  'Zamora': {'province': 'Zamora Chinchipe', 'postalCode': '1901'},
  'Azogues': {'province': 'Cañar', 'postalCode': '0301'},
  'Guaranda': {'province': 'Bolívar', 'postalCode': '0201'},
  'Nueva Loja': {'province': 'Sucumbíos', 'postalCode': '2101'},
  'Chone': {'province': 'Manabí', 'postalCode': '1303'},
  'Santa Elena': {'province': 'Santa Elena', 'postalCode': '2401'},
  'La Libertad': {'province': 'Santa Elena', 'postalCode': '2402'},
  'Salinas': {'province': 'Santa Elena', 'postalCode': '2403'},
  'Francisco de Orellana': {'province': 'Orellana', 'postalCode': '2201'},
};

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _apellidoCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String? _selectedCity;
  String? _selectedProvince;
  String? _selectedPostalCode;
  final _controller = LoginController();

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidoCtrl.dispose();
    _direccionCtrl.dispose();
    _emailCtrl.dispose();
    _telefonoCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList('users') ?? [];
    // Save all form data in the format: name|surname|address|city|province|postalCode|email|phone|password
    final userData = [
      _nombreCtrl.text,
      _apellidoCtrl.text,
      _direccionCtrl.text,
      _selectedCity ?? '',
      _selectedProvince ?? '',
      _selectedPostalCode ?? '',
      _emailCtrl.text,
      _telefonoCtrl.text,
      _passwordCtrl.text,
    ].join('|');
    users.add(userData);
    await prefs.setStringList('users', users);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Create Account', style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyan, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(Icons.person_add, size: 100, color: Colors.white),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nombreCtrl,
                    style: AppTextStyles.input,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      hintStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _apellidoCtrl,
                    style: AppTextStyles.input,
                    decoration: const InputDecoration(
                      hintText: 'Last name',
                      hintStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Last name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _direccionCtrl,
                    style: AppTextStyles.input,
                    decoration: const InputDecoration(
                      hintText: 'Address',
                      hintStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Address is required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCity,
                    style: AppTextStyles.input,
                    decoration: const InputDecoration(
                      hintText: 'City',
                      hintStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    ),
                    items: ecuadorRegions.keys.map((String city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city, style: const TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCity = newValue;
                        _selectedProvince = ecuadorRegions[newValue!]!['province'];
                        _selectedPostalCode = ecuadorRegions[newValue]!['postalCode'];
                      });
                    },
                    validator: (value) => value == null ? 'City is required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedProvince,
                    style: AppTextStyles.input,
                    decoration: const InputDecoration(
                      hintText: 'Province',
                      hintStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    ),
                    items: _selectedCity != null
                        ? [ecuadorRegions[_selectedCity!]!['province']].map((String? province) {
                      return DropdownMenuItem<String>(
                        value: province,
                        child: Text(province ?? '', style: const TextStyle(color: Colors.black)),
                      );
                    }).toList()
                        : [],
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedProvince = newValue;
                      });
                    },
                    validator: (value) => value == null ? 'Province is required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedPostalCode,
                    style: AppTextStyles.input,
                    decoration: const InputDecoration(
                      hintText: 'Zip code',
                      hintStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    ),
                    items: _selectedCity != null
                        ? [ecuadorRegions[_selectedCity!]!['postalCode']].map((String? postalCode) {
                      return DropdownMenuItem<String>(
                        value: postalCode,
                        child: Text(postalCode ?? '', style: const TextStyle(color: Colors.black)),
                      );
                    }).toList()
                        : [],
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPostalCode = newValue;
                      });
                    },
                    validator: (value) => value == null ? 'Postal code is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailCtrl,
                    style: AppTextStyles.input,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    ),
                    validator: (value) => !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value ?? '') ? 'Invalid email' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _telefonoCtrl,
                    style: AppTextStyles.input,
                    decoration: const InputDecoration(
                      hintText: 'Phone',
                      hintStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    ),
                    validator: (value) => value == null || value.length != 10 ? 'Phone number must have 10 digits' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: true,
                    style: AppTextStyles.input,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    ),
                    validator: (value) => value == null || value.length < 4 ? 'Password must be at least 4 characters long.' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _saveUserData();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created successfully')));
                        Navigator.pop(context);
                      }
                    },
                    style: AppButtonStyles.primary,
                    child: const Text('Create Account', style: TextStyle(color: Colors.purple)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}