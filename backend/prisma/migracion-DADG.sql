-- Crear tabla COMPANY
CREATE TABLE company (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Crear tabla EMPLOYEE
CREATE TABLE employee (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    role VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE
);

-- Crear tabla INTERVIEW_FLOW
CREATE TABLE interview_flow (
    id SERIAL PRIMARY KEY,
    description VARCHAR(500) NOT NULL
);

-- Crear tabla POSITION
CREATE TABLE position (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    interview_flow_id INTEGER NOT NULL REFERENCES interview_flow(id) ON DELETE SET NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(100) NOT NULL,
    is_visible BOOLEAN DEFAULT TRUE,
    location VARCHAR(255),
    job_description TEXT,
    requirements TEXT,
    responsibilities TEXT,
    salary_min NUMERIC(10, 2),
    salary_max NUMERIC(10, 2),
    employment_type VARCHAR(100),
    benefits TEXT,
    company_description TEXT,
    application_deadline DATE,
    contact_info VARCHAR(255)
);

-- Crear tabla INTERVIEW_TYPE
CREATE TABLE interview_type (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Crear tabla INTERVIEW_STEP
CREATE TABLE interview_step (
    id SERIAL PRIMARY KEY,
    interview_flow_id INTEGER NOT NULL REFERENCES interview_flow(id) ON DELETE CASCADE,
    interview_type_id INTEGER NOT NULL REFERENCES interview_type(id) ON DELETE RESTRICT,
    name VARCHAR(255) NOT NULL,
    order_index INTEGER NOT NULL CHECK (order_index > 0)
);

-- Crear tabla CANDIDATE
CREATE TABLE candidate (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(50),
    address VARCHAR(255)
);

-- Crear tabla APPLICATION
CREATE TABLE application (
    id SERIAL PRIMARY KEY,
    position_id INTEGER NOT NULL REFERENCES position(id) ON DELETE CASCADE,
    candidate_id INTEGER NOT NULL REFERENCES candidate(id) ON DELETE CASCADE,
    application_date DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(100) NOT NULL,
    notes TEXT
);

-- Crear tabla INTERVIEW
CREATE TABLE interview (
    id SERIAL PRIMARY KEY,
    application_id INTEGER NOT NULL REFERENCES application(id) ON DELETE CASCADE,
    interview_step_id INTEGER NOT NULL REFERENCES interview_step(id) ON DELETE CASCADE,
    employee_id INTEGER NOT NULL REFERENCES employee(id) ON DELETE SET NULL,
    interview_date DATE NOT NULL,
    result VARCHAR(100),
    score INTEGER CHECK (score >= 0),
    notes TEXT
);

-- Índices adicionales sugeridos para consultas frecuentes
CREATE INDEX idx_employee_company ON employee(company_id);
CREATE INDEX idx_position_company ON position(company_id);
CREATE INDEX idx_application_candidate ON application(candidate_id);
CREATE INDEX idx_interview_application ON interview(application_id);

-- Comentarios opcionales para mayor claridad
COMMENT ON TABLE company IS 'Empresas registradas en el sistema';
COMMENT ON TABLE employee IS 'Empleados que pertenecen a una empresa';
COMMENT ON TABLE position IS 'Ofertas laborales publicadas por empresas';
COMMENT ON TABLE interview_flow IS 'Flujos de entrevistas definidos por las empresas';
COMMENT ON TABLE interview_step IS 'Pasos individuales dentro de un flujo de entrevistas';
COMMENT ON TABLE interview_type IS 'Tipos de entrevistas posibles (ej. técnica, HR)';
COMMENT ON TABLE candidate IS 'Personas que aplican a posiciones';
COMMENT ON TABLE application IS 'Aplicaciones de candidatos a posiciones';
COMMENT ON TABLE interview IS 'Entrevistas realizadas a candidatos dentro de aplicaciones';


-- Se agregan nuevas sugerencias. Ver Prompt 3

-- Tabla de tipos de empleo
CREATE TABLE employment_type (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Tabla de estados de aplicación
CREATE TABLE application_status (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Tabla de resultados de entrevista
CREATE TABLE interview_result (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Tabla de beneficios
CREATE TABLE benefit (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Relación posición-beneficio
CREATE TABLE position_benefit (
    position_id INTEGER REFERENCES position(id) ON DELETE CASCADE,
    benefit_id INTEGER REFERENCES benefit(id) ON DELETE CASCADE,
    PRIMARY KEY (position_id, benefit_id)
);

-- Tabla de tags
CREATE TABLE tag (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Relación posición-tag
CREATE TABLE position_tag (
    position_id INTEGER REFERENCES position(id) ON DELETE CASCADE,
    tag_id INTEGER REFERENCES tag(id) ON DELETE CASCADE,
    PRIMARY KEY (position_id, tag_id)
);

-- Historial de cambios de estado en aplicaciones
CREATE TABLE application_log (
    id SERIAL PRIMARY KEY,
    application_id INTEGER REFERENCES application(id) ON DELETE CASCADE,
    status_id INTEGER REFERENCES application_status(id) ON DELETE RESTRICT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT
);

-- Nuevos índices
CREATE INDEX idx_position_title ON position(title);
CREATE INDEX idx_position_status ON position(status);
CREATE INDEX idx_interview_date ON interview(interview_date);
