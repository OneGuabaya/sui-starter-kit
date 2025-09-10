module starter::academia_system {
    use sui::vec_map::{Self, VecMap};
    use std::string::{String, utf8};

    // Structura del estudiante
    public struct Student has key {
        id: UID,
        name: String,
        email: String,
        subjects: VecMap<u64, Grades>,
    }

    // Estructura de las notas
    public struct Grades has store, drop {
        name: String,
        score: u16,
        approved: bool,
    }

    #[error]
    const REGISTRO_EXISTENTE: vector<u8> = b"El identificador del alumno ya existe.";
    #[error]
    const REGISTRO_NO_EXISTE: vector<u8> = b"El identificador del alumno no existe.";

    // Calcula promedio de las notas que tiene 
    //public fun calculate_average(student: &Student): u64 {
    //        let subjects = vec_map::keys(&student.subjects);
    //        let total_score: u64 = 0;
    //        let count: u64 = 0;
//
    //        while (vec::length(&subjects) > 0) {
    //            let key = vec::pop_back(&mut subjects);
    //            let grade_obj = vec_map::borrow(&student.subjects, &key);
    //            total_score = total_score + (grade_obj.score as u64);
    //            count = count + 1;
    //        };
//
    //        if (count == 0) {
    //            0
    //        } else {
    //            total_score / count
    //        }
    //}

    // Crear estudiantes
    public fun add_student(
        ctx: &mut TxContext
        ) {
        let estudiante = Student {
            id: object::new(ctx),
            name: utf8(b"Jesus Viloria"),
            email: utf8(b"viloriajep@gmail.com"),
            subjects: vec_map::empty(),
        };

        transfer::transfer(estudiante, tx_context::sender(ctx));
    }

    // Anadir materia
    public fun add_subjects(
        student: &mut Student, 
        id: u64,
        name: String,
        score: u16
    ) {
        assert!(!student.subjects.contains(&id), REGISTRO_EXISTENTE);

        let approved = if (score > 5) {
            true
        } else {
            false
        };

        let materia = Grades {
           name,
           score,
           approved
        };

        student.subjects.insert(id, materia)
    }

     // Eliminar materia
    public fun delete_subjects(
        student: &mut Student, 
        id: u64,
    ) {
        assert!(student.subjects.contains(&id), REGISTRO_NO_EXISTE);
        student.subjects.remove(&id);
    }

    //Actualiza las notas
    public fun sync_score(
        student: &mut Student, 
        id: u64,
        score: u16
        
    ) {
        assert!(student.subjects.contains(&id), REGISTRO_NO_EXISTE);

        let subject = student.subjects.get_mut(&id);

        let approved = if (score > 5) {
            true
        } else {
            false
        };

        subject.score = score;
        subject.approved = approved;
    }
}