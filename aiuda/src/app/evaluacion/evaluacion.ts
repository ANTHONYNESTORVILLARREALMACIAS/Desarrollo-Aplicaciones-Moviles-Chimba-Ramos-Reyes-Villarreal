import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-evaluacion',
  imports: [CommonModule],
  templateUrl: './evaluacion.html',
  styleUrl: './evaluacion.css'
})
export class Evaluacion {
  resultadoDado: string | null = null; // Variable para almacenar el resultado

  dado(): boolean {
    const num = Math.floor(Math.random() * 6) + 1;
    this.resultadoDado = `Número: ${num} - ${num % 2 === 0 ? 'Par' : 'Impar'}`;
    return num % 2 === 0;
  }
}
