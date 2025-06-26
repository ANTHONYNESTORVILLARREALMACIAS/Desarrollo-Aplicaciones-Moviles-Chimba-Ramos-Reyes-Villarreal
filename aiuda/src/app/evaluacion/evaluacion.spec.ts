import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Evaluacion } from './evaluacion';

describe('Evaluacion', () => {
  let component: Evaluacion;
  let fixture: ComponentFixture<Evaluacion>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [Evaluacion]
    })
    .compileComponents();

    fixture = TestBed.createComponent(Evaluacion);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(Evaluacion);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('el campo nombre debe ser Su Nombre', () => {
    const nombre = fixture.nativeElement.querySelector('#nombre');
    nombre.value = 'Su Nombre';
    nombre.dispatchEvent(new Event('input'));
    expect(nombre.value).toEqual('Su Nombre');
  });

  it('nota1 debe ser menor que nota2', () => {
    const nota1 = fixture.nativeElement.querySelector('#nota1');
    const nota2 = fixture.nativeElement.querySelector('#nota2');
    nota1.value = 4;
    nota2.value = 7;
    nota1.dispatchEvent(new Event('input'));
    nota2.dispatchEvent(new Event('input'));
    expect(Number(nota1.value)).toBeLessThan(Number(nota2.value));
  });

  it('el textarea debe contener Universidad de las Fuerzas Armadas ESPE', () => {
    const comentarios = fixture.nativeElement.querySelector('#comentarios');
    comentarios.value = 'Universidad de las Fuerzas Armadas ESPE';
    comentarios.dispatchEvent(new Event('input'));
    expect(comentarios.value).toMatch('Universidad de las Fuerzas Armadas ESPE');
  });

  it('dado debe retornar true si es par', () => {
    spyOn(Math, 'random').and.returnValue(0.3); // Simula 2
    const resultado = component.dado();
    expect(resultado).toBeTruthy();
  });

  it('el h1 debe contener Evaluación Segundo Parcial', () => {
    const h1 = fixture.nativeElement.querySelector('h1');
    expect(h1.textContent).toContain('Evaluación Segundo Parcial');
  });
});
