import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RegisterAgenciesComponent } from './register-agencies.component';

describe('RegisterAgenciesComponent', () => {
  let component: RegisterAgenciesComponent;
  let fixture: ComponentFixture<RegisterAgenciesComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RegisterAgenciesComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RegisterAgenciesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
