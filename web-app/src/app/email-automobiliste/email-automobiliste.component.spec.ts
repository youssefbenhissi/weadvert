import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EmailAutomobilisteComponent } from './email-automobiliste.component';

describe('EmailAutomobilisteComponent', () => {
  let component: EmailAutomobilisteComponent;
  let fixture: ComponentFixture<EmailAutomobilisteComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EmailAutomobilisteComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EmailAutomobilisteComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
